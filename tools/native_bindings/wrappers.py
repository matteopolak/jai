"""Independently authored convenience bodies for documented signatures.

This module deliberately does not infer behavior from legacy tests. Native
macro arithmetic follows the corresponding public C APIs.
"""
import re


def simple_body(module, name, condition=''):
    if module == 'xxHash':
        bodies = {
            'XXH_versionNumber': 'return binding_XXH_versionNumber();',
            'native_XXH32': 'return binding_XXH32(input, cast(u64) len, seed);',
            'native_XXH64': 'return binding_XXH64(input, cast(u64) len, cast(u64) seed);',
            'XXH32_reset': 'if binding_XXH32_reset(state, seed) != 0 binding_abort();',
            'XXH64_reset': 'if binding_XXH64_reset(state, seed) != 0 binding_abort();',
            'XXH32_update': 'if len == 0 return; if binding_XXH32_update(state, input, cast(u64) len) != 0 binding_abort();',
            'XXH64_update': 'if len == 0 return; if binding_XXH64_update(state, input, cast(u64) len) != 0 binding_abort();',
            'XXH32_digest': 'return binding_XXH32_digest(state);',
            'XXH64_digest': 'return binding_XXH64_digest(state);',
        }
        return bodies.get(name)
    if module == 'freetype':
        flags = {'FT_HAS_HORIZONTAL': 'HORIZONTAL', 'FT_HAS_VERTICAL': 'VERTICAL',
                 'FT_HAS_KERNING': 'KERNING', 'FT_IS_SCALABLE': 'SCALABLE',
                 'FT_IS_SFNT': 'SFNT', 'FT_IS_FIXED_WIDTH': 'FIXED_WIDTH',
                 'FT_HAS_FIXED_SIZES': 'FIXED_SIZES', 'FT_HAS_GLYPH_NAMES': 'GLYPH_NAMES',
                 'FT_HAS_MULTIPLE_MASTERS': 'MULTIPLE_MASTERS', 'FT_IS_VARIATION': 'VARIATION',
                 'FT_IS_CID_KEYED': 'CID_KEYED', 'FT_IS_TRICKY': 'TRICKY',
                 'FT_HAS_COLOR': 'COLOR', 'FT_HAS_SVG': 'SVG', 'FT_HAS_SBIX': 'SBIX',
                 'FT_HAS_SBIX_OVERLAY': 'SBIX_OVERLAY'}
        if name in flags:
            return 'return (face.face_flags & FT_FACE_FLAG_' + flags[name] + ') != 0;'
        if name == 'FT_IS_NAMED_INSTANCE':
            return 'return (face.face_index & 0x7fff0000) != 0;'
    if module == 'Vulkan':
        expressions = {
            'VK_MAKE_VERSION': '(major << 22) | (minor << 12) | patch',
            'VK_VERSION_MAJOR': 'version >> 22', 'VK_VERSION_MINOR': '(version >> 12) & 0x3ff',
            'VK_VERSION_PATCH': 'version & 0xfff',
            'VK_MAKE_API_VERSION': '(variant << 29) | (major << 22) | (minor << 12) | patch',
            'VK_API_VERSION_VARIANT': 'version >> 29',
            'VK_API_VERSION_MAJOR': '(version >> 22) & 0x7f',
            'VK_API_VERSION_MINOR': '(version >> 12) & 0x3ff',
            'VK_API_VERSION_PATCH': 'version & 0xfff',
            'vk_unmake_version': 'VK_Version.{VK_VERSION_MAJOR(vk_version), VK_VERSION_MINOR(vk_version), VK_VERSION_PATCH(vk_version)}',
        }
        if name in expressions:
            return 'return ' + expressions[name] + ';'
    if module == 'Windows':
        bodies = {
            'SUCCEEDED': 'return hr >= 0;', 'FAILED': 'return hr < 0;',
            'TOUCH_COORD_TO_PIXEL': 'return cast(float) c / 100.0;',
            'HasOverlappedIoCompleted': 'return overlapped.Internal != 0x103;',
            'MAKELANGID': 'return (usSubLanguage << 10) | usPrimaryLanguage;',
            'operator ==': 'if a.Data1 != b.Data1 || a.Data2 != b.Data2 || a.Data3 != b.Data3 return false; for i: 0..7 if a.Data4[i] != b.Data4[i] return false; return true;',
            'safe_release': 'if obj != null obj.vtable.Release(obj);',
        }
        if name in bodies:
            return bodies[name]
        if name == 'safe_release_and_reset':
            return 'if <<b != null { safe_release(cast(*IUnknown) <<b); <<b = null; }'
    if module == 'POSIX':
        bodies = {'errno': 'return cast(OS_Error_Code) <<binding_errno_address();',
                  'set_errno': '<<binding_errno_address() = cast(s32) value;',
                  'IFTODT': 'return (mode & S_IFMT) >> 12;',
                  'DTTOIF': 'return dirtype << 12;'}
        if name in bodies:
            return bodies[name]
        if name.startswith('S_IS'):
            flag = {'S_ISDIR': 'S_IFDIR', 'S_ISCHR': 'S_IFCHR', 'S_ISBLK': 'S_IFBLK',
                    'S_ISREG': 'S_IFREG', 'S_ISFIFO': 'S_IFIFO', 'S_ISLNK': 'S_IFLNK',
                    'S_ISSOCK': 'S_IFSOCK'}.get(name)
            if flag:
                return 'return (mode & S_IFMT) == ' + flag + ';'
        waits = {'WEXITSTATUS': '(status >> 8) & 255', 'WTERMSIG': 'status & 127',
                 'WSTOPSIG': '(status >> 8) & 255', 'WIFEXITED': '(status & 127) == 0',
                 'WIFSIGNALED': '(status & 127) != 0 && (status & 127) != 127',
                 'WIFSTOPPED': '(status & 255) == 127', 'WIFCONTINUED': 'status == 0xffff',
                 'WCOREDUMP': 'status & 128'}
        if name in waits:
            if name == 'WIFCONTINUED' and '.MACOS' in condition:
                return 'return (status & 127) == 127 && (status >> 8) == 19;'
            if name == 'WIFSTOPPED' and '.MACOS' in condition:
                return 'return (status & 127) == 127 && (status >> 8) != 19;'
            if name == 'WSTOPSIG' and '.MACOS' in condition:
                return 'return status >> 8;'
            return 'return ' + waits[name] + ';'
        if name in ('stat', 'lstat'):
            return 'return syscall(SYS_' + name + ', path, buf);'
        if name == 'fstat':
            return 'return syscall(SYS_fstat, fd, buf);'
    if module == 'Linux':
        if name == 'io_uring_setup':
            return 'return cast(s32) syscall(425, entries, p);'
        if name == 'io_uring_register':
            return 'return cast(s32) syscall(427, fd, opcode, arg, nr_args);'
    if module == 'SDL':
        bodies = {
            'SDL_VERSION': 'x.major = SDL_MAJOR_VERSION; x.minor = SDL_MINOR_VERSION; x.patch = SDL_PATCHLEVEL;',
            'SDL_VERSIONNUM': 'return X*1000 + Y*100 + Z;',
            'SDL_WINDOWPOS_UNDEFINED_DISPLAY': 'return SDL_WINDOWPOS_UNDEFINED_MASK | x;',
            'SDL_WINDOWPOS_CENTERED_DISPLAY': 'return SDL_WINDOWPOS_CENTERED_MASK | x;',
            'SDL_LoadBMP': 'return SDL_LoadBMP_RW(SDL_RWFromFile(path, "rb"), 1);',
            'SDL_SCANCODE_TO_KEYCODE': 'return cast(s32) scancode | (1 << 30);',
            'SDL_BUTTON': 'return 1 << (x-1);',
            'SDL_PointInRect': 'return cast(SDL_bool) (p.x >= r.x && p.x < r.x+r.w && p.y >= r.y && p.y < r.y+r.h);',
            'SDL_RectEmpty': 'return cast(SDL_bool) (!r || r.w <= 0 || r.h <= 0);',
            'SDL_RectEquals': 'return cast(SDL_bool) (a != null && b != null && a.x == b.x && a.y == b.y && a.w == b.w && a.h == b.h);',
            'SDL_AUDIO_BITSIZE': 'return x & SDL_AUDIO_MASK_BITSIZE;',
            'SDL_AUDIO_ISFLOAT': 'return (x & SDL_AUDIO_MASK_DATATYPE) != 0;',
            'SDL_AUDIO_ISBIGENDIAN': 'return (x & SDL_AUDIO_MASK_ENDIAN) != 0;',
            'SDL_AUDIO_ISSIGNED': 'return (x & SDL_AUDIO_MASK_SIGNED) != 0;',
            'SDL_AUDIO_ISINT': 'return !SDL_AUDIO_ISFLOAT(x);',
            'SDL_AUDIO_ISLITTLEENDIAN': 'return !SDL_AUDIO_ISBIGENDIAN(x);',
            'SDL_AUDIO_ISUNSIGNED': 'return !SDL_AUDIO_ISSIGNED(x);',
        }
        return bodies.get(name)
    if module == 'macOS' and name == 'VM_MAKE_TAG':
        return 'return val << 24;'
    if module == 'iOS' and name == 'get_ios_target_triple':
        return 'if cpu == .ARM64 return "arm64-apple-ios"; return "x86_64-apple-ios";'
    if module == 'X11':
        bodies = {
            'DefaultScreen': 'return display.default_screen;',
            'ScreenOfDisplay': 'return *display.screens[scr];',
            'DefaultScreenOfDisplay': 'return ScreenOfDisplay(display, DefaultScreen(display));',
            'DefaultRootWindow': 'return DefaultScreenOfDisplay(display).root;',
            'DefaultGC': 'return ScreenOfDisplay(display, scr).default_gc;',
            'x_rgb_to_color': 'color: XColor; color.red = cast(u16) _r * 257; color.green = cast(u16) _g * 257; color.blue = cast(u16) _b * 257; color.flags = 7; return color;',
            'x_textwidth': 'return XTextWidth(font, msg.data, cast(s32) msg.count);',
        }
        return bodies.get(name)
    if module == 'telemetry3' and condition == '!ENABLED || OS != .WINDOWS':
        return 'return false;' if name == 'telemetry_enabled' else ''
    return None


def forwarding_body(module, declaration, declarations, parts, parse):
    name, params, args, tail = parts
    prefix = 'return ' if '->' in tail and not re.search(r'->\s*(?:void|\(\))', tail) else ''
    if module == 'Linux' and name == 'io_uring_enter':
        signal = 'null' if len(args) == 4 else args[-1]
        size = 'size_of(io_uring_getevents_arg)' if 'io_uring_getevents_arg' in params[-1] else '8'
        return 'return cast(s32) syscall(426, fd, to_submit, min_complete, flags, ' + signal + ', ' + size + ');'
    if module == 'Curl' and name.startswith('curl_m'):
        values = ['cformat' if a == 'format' else '..' + a if a == '__args' else a for a in args]
        return 'cformat := Native.terminated_copy(format); defer Native.release(cformat); return ' + name + '_CFormat(' + ', '.join(values) + ');'
    # A value overload forwarding to its documented pointer overload. Comparing
    # every parameter prevents accidentally selecting a different native overload.
    for native in declarations:
        if native.name != name or '#foreign' not in native.code:
            continue
        if native.condition and declaration.condition and native.condition != declaration.condition:
            continue
        target = parse(native.code)
        if not target or len(target[1]) != len(params):
            continue
        call_args, changed, compatible = [], False, True
        for arg, public_param, native_param in zip(args, params, target[1]):
            def ty(p):
                return p.split(':', 1)[1].split('=', 1)[0].strip() if ':' in p else ''
            public_type, native_type = ty(public_param), ty(native_param)
            if native_type == public_type:
                call_args.append(arg)
            elif native_type == '*' + public_type:
                call_args.append('*' + arg)
                changed = True
            else:
                compatible = False
                break
        if changed and compatible:
            return prefix + name + '(' + ', '.join(call_args) + ');'
    return None
