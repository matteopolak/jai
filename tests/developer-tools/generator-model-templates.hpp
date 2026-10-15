template<typename T, typename U> struct OriginalGeneric {
    T value;
    T *next;
    const U *other;
    U identity(T argument);
};
template<int N> struct OriginalNonType { int value; };
template<typename... T> struct OriginalPack { int value; };
