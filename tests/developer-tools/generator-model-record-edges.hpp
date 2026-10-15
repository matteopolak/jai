namespace OriginalLeft { struct Shared { int field; }; }
namespace OriginalRight {
typedef OriginalLeft::Shared Shared;
Shared *value;
}
template<typename T> struct OriginalUnsupported;
template<> struct OriginalUnsupported<int> { int field; };
template<> struct OriginalUnsupported<double> { double field; };
struct OriginalAfterUnsupported { int field; };
