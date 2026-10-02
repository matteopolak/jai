// Normalized API contracts; reference procedure bodies were discarded.
marg_prearg_size :: 0;
objc_super :: struct {
    receiver: id;
    class: Class;
}
objc_msgSend :: () -> void #foreign libobjc;
objc_msgSendSuper :: () -> void #foreign libobjc;
method_invoke :: () -> void #foreign libobjc;
_objc_msgForward :: () -> void #foreign libobjc;
marg_list :: *void;
#scope_file
libobjc :: #system_library "libobjc";
