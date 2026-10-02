// Independently normalized ABI contract. No reference procedure bodies or binaries.
SDL_HasClipboardText :: ( ) -> SDL_bool #foreign SDL2 ;
SDL_GetClipboardText :: ( ) -> * u8 #foreign SDL2 ;
SDL_SetClipboardText :: ( text : * u8 ) -> s32 #foreign SDL2 ;
