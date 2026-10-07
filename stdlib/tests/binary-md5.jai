#import "md5";

#assert(md5("") == "d41d8cd98f00b204e9800998ecf8427e");
#assert(md5("a") == "0cc175b9c0f1b6a831c399e269772661");
#assert(md5("abc") == "900150983cd24fb0d6963f7d28e17f72");
#assert(md5("message digest") == "f96b697d7cb7938d525a2f31aaf161d0");
#assert(md5("abcdefghijklmnopqrstuvwxyz") == "c3fcd3d76192e4007dfb496cca67e13b");
#assert(md5("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789") == "d174ab98d277d9f5a5611c2c9f419d9f");
#assert(md5("12345678901234567890123456789012345678901234567890123456789012345678901234567890") == "57edf4a22be3c955ac49da2e2107b67a");
#assert(md5("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") == "ef1772b6dff9a122358552954ad0df65");
#assert(md5("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") == "3b0c8ac703f828b04c6c197006d17218");
#assert(md5("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") == "b06521f39153d618550606be297466d5");
#assert(md5("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa") == "014842d480b571495a4a0363793f7367");
