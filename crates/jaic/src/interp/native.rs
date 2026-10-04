//! Native foreign calls: dynamic library loading and calling C functions
//! through fixed-shape trampolines.
//!
//! On the supported 64-bit C ABIs (System V x86-64 and AArch64) integer and
//! floating-point arguments are assigned to separate register files, so any
//! signature with at most 8 integer and 8 floating-point arguments can be
//! called through one prototype taking 8 of each. Structs passed or returned by
//! value are split into register pieces by `abi` (the same classification the
//! LLVM backend uses); larger ones go by address or through a hidden result pointer.
// The calling machinery is only reachable on the CPUs `call` supports (not on wasm).
#![cfg_attr(
    not(any(target_arch = "x86_64", target_arch = "aarch64")),
    allow(dead_code, unused_imports)
)]
use crate::abi::{self, Arch, Passing, Piece, PieceTy};
use crate::ir::{Sig, Ty};

#[derive(Clone)]
pub struct Library {
    handle: usize,
}

/// Directories searched for libraries by name before the system's, set once by the driver
/// (the third-party libraries `tools/build_native_libs.py` builds; see docs/native-libs.md).
static LIBRARY_DIRS: std::sync::OnceLock<Vec<std::path::PathBuf>> = std::sync::OnceLock::new();

pub fn set_library_dirs(dirs: Vec<std::path::PathBuf>) {
    let _ = LIBRARY_DIRS.set(dirs);
}

pub fn library_dirs() -> &'static [std::path::PathBuf] {
    LIBRARY_DIRS.get().map_or(&[], Vec::as_slice)
}

#[cfg(unix)]
mod sys {
    use std::ffi::{c_char, c_int, c_void};
    unsafe extern "C" {
        pub fn dlopen(filename: *const c_char, flags: c_int) -> *mut c_void;
        pub fn dlsym(handle: *mut c_void, symbol: *const c_char) -> *mut c_void;
    }
    pub const RTLD_NOW: c_int = 2;
    #[cfg(target_os = "macos")]
    pub const RTLD_DEFAULT: *mut c_void = -2isize as *mut c_void;
    #[cfg(not(target_os = "macos"))]
    pub const RTLD_DEFAULT: *mut c_void = std::ptr::null_mut();
}

impl Library {
    /// Open a library by Jai name (`"c"`, `"SDL2"`, `"libs/foo"`...).
    #[cfg(unix)]
    pub fn open(name: &str, system: bool, base_dir: &str) -> Option<Library> {
        use std::ffi::CString;
        if system && matches!(name, "c" | "libc" | "m" | "libm" | "pthread" | "dl") {
            return Some(Library {
                handle: sys::RTLD_DEFAULT as usize,
            });
        }
        let ext = if cfg!(target_os = "macos") {
            "dylib"
        } else {
            "so"
        };
        let mut candidates = Vec::new();
        let file = std::path::Path::new(name)
            .file_name()
            .map(|f| f.to_string_lossy().into_owned())
            .unwrap_or_default();
        let dir = std::path::Path::new(name)
            .parent()
            .map(|p| p.to_string_lossy().into_owned())
            .unwrap_or_default();
        let joined = |d: &str, f: &str| {
            if d.is_empty() {
                f.to_string()
            } else {
                format!("{d}/{f}")
            }
        };
        if !system {
            let base = joined(base_dir, &dir);
            candidates.push(joined(&base, &format!("{file}.{ext}")));
            candidates.push(joined(&base, &format!("lib{file}.{ext}")));
        }
        let bare = name.strip_prefix("lib").unwrap_or(name);
        for d in library_dirs() {
            candidates.push(d.join(format!("lib{bare}.{ext}")).display().to_string());
        }
        candidates.push(format!("lib{name}.{ext}"));
        candidates.push(format!("{name}.{ext}"));
        if cfg!(target_os = "macos") {
            candidates.push(format!(
                "/System/Library/Frameworks/{name}.framework/{name}"
            ));
            candidates.push(format!("/opt/homebrew/lib/lib{name}.dylib"));
        }
        for c in candidates {
            let Ok(path) = CString::new(c) else {
                continue;
            };
            let handle = unsafe { sys::dlopen(path.as_ptr(), sys::RTLD_NOW) };
            if !handle.is_null() {
                return Some(Library {
                    handle: handle as usize,
                });
            }
        }
        None
    }

    #[cfg(not(unix))]
    pub fn open(_name: &str, _system: bool, _base_dir: &str) -> Option<Library> {
        None
    }
}

/// Resolve a symbol in `lib`, or anywhere in the process.
#[cfg(unix)]
pub fn lookup(lib: Option<&Library>, symbol: &str) -> Option<u64> {
    let name = std::ffi::CString::new(symbol).ok()?;
    let handle = lib.map_or(sys::RTLD_DEFAULT, |l| l.handle as *mut std::ffi::c_void);
    let mut p = unsafe { sys::dlsym(handle, name.as_ptr()) };
    if p.is_null() {
        p = unsafe { sys::dlsym(sys::RTLD_DEFAULT, name.as_ptr()) };
    }
    (!p.is_null()).then_some(p as u64)
}

#[cfg(not(unix))]
pub fn lookup(_lib: Option<&Library>, _symbol: &str) -> Option<u64> {
    None
}

/// The register arguments of one call: 8 integer and 8 floating-point registers.
#[derive(Default)]
struct Regs {
    ints: [u64; 8],
    floats: [u64; 8],
    ni: usize,
    nf: usize,
}

impl Regs {
    fn int(&mut self, v: u64) -> Result<(), String> {
        if self.ni == 8 {
            return Err("foreign call has more than 8 integer arguments".into());
        }
        self.ints[self.ni] = v;
        self.ni += 1;
        Ok(())
    }
    /// An `f32` travels in the low half of the register.
    fn float(&mut self, bits: u64) -> Result<(), String> {
        if self.nf == 8 {
            return Err("foreign call has more than 8 floating-point arguments".into());
        }
        self.floats[self.nf] = bits;
        self.nf += 1;
        Ok(())
    }
}

/// Little-endian bytes `[addr, addr + len)` (len <= 8) as a `u64`.
///
/// SAFETY: interpreter addresses are host addresses of live memory.
unsafe fn read_bytes(addr: u64, len: u64) -> u64 {
    let mut out = [0u8; 8];
    let len = len.min(8) as usize;
    unsafe { std::ptr::copy_nonoverlapping(addr as *const u8, out.as_mut_ptr(), len) };
    u64::from_le_bytes(out)
}

/// SAFETY: as `read_bytes`.
unsafe fn write_bytes(addr: u64, value: u64, len: u64) {
    let bytes = value.to_le_bytes();
    let len = len.min(8) as usize;
    unsafe { std::ptr::copy_nonoverlapping(bytes.as_ptr(), addr as *mut u8, len) };
}

// Return shapes. A C aggregate returned in registers comes back as one of these: Rust lays
// them out and classifies them like the C struct with the same register classes (an `f32`
// member arrives in the low half of its `f64` register).
#[repr(C)]
#[derive(Clone, Copy)]
struct II(u64, u64);
#[repr(C)]
#[derive(Clone, Copy)]
struct IF(u64, f64);
#[repr(C)]
#[derive(Clone, Copy)]
struct FI(f64, u64);
#[repr(C)]
#[derive(Clone, Copy)]
struct FF(f64, f64);
#[repr(C)]
#[derive(Clone, Copy)]
struct FFF(f64, f64, f64);
#[repr(C)]
#[derive(Clone, Copy)]
struct FFFF(f64, f64, f64, f64);
/// Large aggregates come back through a hidden pointer the callee fills.
const SRET_WORDS: usize = 64;
#[repr(C)]
#[derive(Clone, Copy)]
struct Sret([u64; SRET_WORDS]);

/// Call `addr` through a prototype taking 8 integer and 8 float registers, returning `R`.
///
/// SAFETY: `addr` is a C function whose arguments fit the registers in `regs`.
unsafe fn call_as<R>(addr: u64, regs: &Regs) -> R {
    type Proto<R> = unsafe extern "C" fn(
        u64,
        u64,
        u64,
        u64,
        u64,
        u64,
        u64,
        u64,
        f64,
        f64,
        f64,
        f64,
        f64,
        f64,
        f64,
        f64,
    ) -> R;
    let f: Proto<R> = unsafe { std::mem::transmute::<usize, Proto<R>>(addr as usize) };
    let [i0, i1, i2, i3, i4, i5, i6, i7] = regs.ints;
    let [f0, f1, f2, f3, f4, f5, f6, f7] = regs.floats.map(f64::from_bits);
    unsafe {
        f(
            i0, i1, i2, i3, i4, i5, i6, i7, f0, f1, f2, f3, f4, f5, f6, f7,
        )
    }
}

/// Call the C function at `addr`. Arguments are raw IR values classified by `sig`; a
/// by-value struct argument is a pointer to its memory, and a struct result is written
/// through the last IR argument (the out-pointer).
#[cfg(any(target_arch = "x86_64", target_arch = "aarch64"))]
pub fn call(addr: u64, args: &[u64], sig: &Sig) -> Result<Vec<u64>, String> {
    let arch = Arch::host().ok_or("native foreign calls are not available on this CPU")?;
    let cabi = sig.c_abi.as_deref();
    let ret_layout = cabi.and_then(|c| c.ret.as_ref());
    let mut regs = Regs::default();
    // Copies of large aggregates passed by address; alive until the call returns.
    let mut copies: Vec<Vec<u64>> = Vec::new();
    let mut out_ptr = 0;
    for (i, &a) in args.iter().enumerate() {
        if ret_layout.is_some() && i + 1 == sig.params.len() {
            out_ptr = a;
            continue;
        }
        let layout = cabi.and_then(|c| c.params.get(i)).and_then(Option::as_ref);
        let Some(layout) = layout else {
            if sig.params.get(i).is_some_and(|t| t.is_float()) {
                regs.float(a)?;
            } else {
                regs.int(a)?;
            }
            continue;
        };
        match abi::classify_arg(arch, layout) {
            Passing::Registers(pieces) => {
                for p in pieces {
                    // SAFETY: `a` points at the aggregate, `layout.size` bytes long.
                    let v = unsafe { read_bytes(a + p.offset, layout.size - p.offset) };
                    if p.ty == PieceTy::I64 {
                        regs.int(v)?;
                    } else {
                        regs.float(v)?;
                    }
                }
            }
            Passing::Indirect => {
                let mut copy = vec![0u64; layout.size.div_ceil(8) as usize];
                // SAFETY: as above; the copy is at least `layout.size` bytes.
                unsafe {
                    std::ptr::copy_nonoverlapping(
                        a as *const u8,
                        copy.as_mut_ptr() as *mut u8,
                        layout.size as usize,
                    )
                };
                regs.int(copy.as_ptr() as u64)?;
                copies.push(copy);
            }
            Passing::ByVal => {
                return Err(
                    "the interpreter cannot pass a struct larger than 16 bytes by value on x86-64"
                        .into(),
                );
            }
        }
    }
    let Some(layout) = ret_layout else {
        return Ok(scalar_call(addr, &regs, sig.returns.first().copied()));
    };
    // SAFETY (all calls below): the callee's declared C signature matches these registers.
    // `#cpp_return_type_is_non_pod` results always use the hidden result pointer.
    let forced_sret = cabi.is_some_and(|c| c.ret_indirect);
    match if forced_sret {
        None
    } else {
        abi::classify_ret(arch, layout)
    } {
        None => {
            if layout.size as usize > SRET_WORDS * 8 {
                return Err(format!(
                    "the interpreter cannot return a {}-byte struct from a foreign procedure",
                    layout.size
                ));
            }
            let r: Sret = unsafe { call_as(addr, &regs) };
            unsafe {
                std::ptr::copy_nonoverlapping(
                    r.0.as_ptr() as *const u8,
                    out_ptr as *mut u8,
                    layout.size as usize,
                )
            };
        }
        Some(pieces) => {
            let int = |p: &Piece| p.ty == PieceTy::I64;
            let words: Vec<u64> = match pieces.as_slice() {
                [] => {
                    unsafe { call_as::<()>(addr, &regs) };
                    Vec::new()
                }
                [a] if int(a) => vec![unsafe { call_as::<u64>(addr, &regs) }],
                [_] => vec![unsafe { call_as::<f64>(addr, &regs) }.to_bits()],
                [a, b] => match (int(a), int(b)) {
                    (true, true) => {
                        let r: II = unsafe { call_as(addr, &regs) };
                        vec![r.0, r.1]
                    }
                    (true, false) => {
                        let r: IF = unsafe { call_as(addr, &regs) };
                        vec![r.0, r.1.to_bits()]
                    }
                    (false, true) => {
                        let r: FI = unsafe { call_as(addr, &regs) };
                        vec![r.0.to_bits(), r.1]
                    }
                    (false, false) => {
                        let r: FF = unsafe { call_as(addr, &regs) };
                        vec![r.0.to_bits(), r.1.to_bits()]
                    }
                },
                [_, _, _] => {
                    let r: FFF = unsafe { call_as(addr, &regs) };
                    vec![r.0.to_bits(), r.1.to_bits(), r.2.to_bits()]
                }
                [_, _, _, _] => {
                    let r: FFFF = unsafe { call_as(addr, &regs) };
                    vec![r.0.to_bits(), r.1.to_bits(), r.2.to_bits(), r.3.to_bits()]
                }
                _ => return Err("unsupported C aggregate return shape".into()),
            };
            for (p, w) in pieces.iter().zip(words) {
                let size = match p.ty {
                    PieceTy::F32 => 4,
                    _ => 8,
                };
                // SAFETY: the out-pointer addresses `layout.size` writable bytes.
                unsafe { write_bytes(out_ptr + p.offset, w, size.min(layout.size - p.offset)) };
            }
        }
    }
    drop(copies);
    Ok(Vec::new())
}

/// A call whose result is a scalar (or nothing).
fn scalar_call(addr: u64, regs: &Regs, ret: Option<Ty>) -> Vec<u64> {
    // SAFETY: the address comes from the dynamic linker for a declared foreign procedure.
    match ret {
        Some(t) if t.is_float() => {
            let bits = unsafe { call_as::<f64>(addr, regs) }.to_bits();
            vec![if t == Ty::F32 {
                bits & 0xffff_ffff
            } else {
                bits
            }]
        }
        Some(t) => {
            let r = unsafe { call_as::<u64>(addr, regs) };
            vec![match t {
                Ty::I8 => r & 0xff,
                Ty::I16 => r & 0xffff,
                Ty::I32 => r & 0xffff_ffff,
                _ => r,
            }]
        }
        None => {
            unsafe { call_as::<u64>(addr, regs) };
            Vec::new()
        }
    }
}

#[cfg(not(any(target_arch = "x86_64", target_arch = "aarch64")))]
pub fn call(_addr: u64, _args: &[u64], _sig: &Sig) -> Result<Vec<u64>, String> {
    Err("native foreign calls are not available on this platform".into())
}
