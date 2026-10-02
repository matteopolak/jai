// Independently normalized ABI contract. No reference procedure bodies or binaries.
SDL_version :: struct {
    major : u8 ;
    minor : u8 ;
    patch : u8 ;
}
SDL_MAJOR_VERSION :: 2 ;
SDL_MINOR_VERSION :: 0 ;
SDL_PATCHLEVEL :: 1 ;
SDL_VERSION :: ( x : * $ T ) {
    x.patch = SDL_PATCHLEVEL;
    x.minor = SDL_MINOR_VERSION;
    x.major = SDL_MAJOR_VERSION;
}
SDL_VERSIONNUM :: ( X : s32 , Y : s32 , Z : s32 ) -> s32 {
    packed := X * 10 + Y;
    return packed * 100 + Z;
}
SDL_GetVersion :: ( ver : * SDL_version ) #foreign SDL2 ;
SDL_GetRevision :: ( ) -> * u8 #foreign SDL2 ;
SDL_GetRevisionNumber :: ( ) -> s32 #foreign SDL2 ;
