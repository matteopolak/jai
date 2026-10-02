// Normalized API contracts; reference procedure bodies were discarded.
marg_prearg_size :: 0;
objc_super :: struct {
    receiver: id;
    class: Class;
}
objc_msgSend :: (self: id, op: SEL, __args: ..Any) -> id #foreign libobjc;
objc_msgSendSuper :: (super: *objc_super, op: SEL, __args: ..Any) -> id #foreign libobjc;
objc_msgSend_stret :: (self: id, op: SEL, __args: ..Any) -> void #foreign libobjc;
objc_msgSendSuper_stret :: (super: *objc_super, op: SEL, __args: ..Any) -> void #foreign libobjc;
method_invoke :: (receiver: id, m: Method, __args: ..Any) -> id #foreign libobjc;
method_invoke_stret :: (receiver: id, m: Method, __args: ..Any) -> void #foreign libobjc;
_objc_msgForward :: (receiver: id, sel: SEL, __args: ..Any) -> id #foreign libobjc;
_objc_msgForward_stret :: (receiver: id, sel: SEL, __args: ..Any) -> void #foreign libobjc;
marg_list :: *void;
#scope_file
libobjc :: #system_library "libobjc";
