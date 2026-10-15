# Developer tooling remaining function matrix

Generated from the reviewed per-API inventory by tools/audit_developer_tools.py. Native source/symbol coverage is distinct from invocation. Supported subsets have additional limits in the progress/deviations documents; this table is not a claim that other paths are complete.

[Precise questions](../specs/stdlib/developer-tools-questions.md), [verified effects](developer-tools-progress.md), [limits and dependencies](developer-tools-deviations.md), [native integration plan](../developer-tools-native-integration.md).

## Bindings_Generator

155 function names have pending declarations; 217 native function names still lack invocation fixtures.

| Function | Reviewed overload variants | Pending variants | Next work / precise question |
| --- | ---: | ---: | --- |
| `_create_declaration` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `add_access_flags` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `add_type_flags` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_as_signed_integer_hex` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_as_unsigned_integer_hex` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_bitfield_helpers` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_calling_convention_directives` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_cpp_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_cpp_type_modifiers` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_cpp_wrapper` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_elsewhere` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_indentation` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_integer` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_maybe_left_shift` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_maybe_right_shift` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_parent_field_path` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_parent_path` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_postfix_comment` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_prefix_comment` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_template_instantiation_params` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `append_type_info_directives` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `as_str` | 4 | 4 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `avoid_cpp_keywords` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `avoid_name_clash` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `avoid_reserved_names` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `can_omit_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `check_if_foreign_function_should_be_omitted` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `check_macro_value` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `compute_enum_names` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `contains_equivalent_function` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `convert_children_to_expression` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `convert_objc_selector_name_to_function_identifier` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `count_asterisks` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `count_namespace_refs` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_declaration` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_declaration_inner` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_elaborated_type` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_empty_struct_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_enum` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_expression_from_cursor` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_function` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_function_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_literal` | 3 | 3 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_macro_definition` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_namespace` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_objc_interface` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_objc_type_param` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_omit_cpp_functions_visitor` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_reference_expression` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_struct` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_type_inner` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_typedef` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `create_variable_declaration` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `debug_print_cursor` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `deinit_generator` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `ensure_local_libclang_exists` | 2 | 2 | Bindings_Generator question11: installation/copy policy |
| `exceeds_signed_int_value` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `expect_tokens` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `fill_comment` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `fill_location_and_comment_if_needed` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `fill_template_arguments` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `fill_template_arguments_for_expression` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_and_check_macro_identifier` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_closing_paren_token_index` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_first_member_offset` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_lib_for_foreign_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_name_clash` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_or_create_enum_for_macro` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_or_create_extra_info` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_referenced_declaration` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `find_underlying_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `finish_bitfield` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `fix_macos_foreign_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `function_has_a_valist_arg` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `function_is_missing_foreign_library` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `functions_are_equivalent` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_enum_value_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_libc_paths` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_name_alignment` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_name_for_cursor` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_primitive_or_array_primitive_type_size` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_scoped_token_string` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_type_alignment` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_type_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `handle_toplevel_cursors` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `init_generator` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_16byte_integer_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_assignment_operator` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_char_pointer_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_extern_declaration` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_function_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_incomplete_array` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_operator` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_operator_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_pointer_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_prefix_comment` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_struct_field` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_target_type_signed` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_target_type_unsigned` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_targeting_apple_os` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_token` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_va_list` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_valid_identifier_start` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_zero_int_expression` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `log` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `log_error` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `macro_literals_are_equal` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `macro_values_are_equal` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `make_valid_identifer` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `maybe_add_spacing` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `maybe_add_to_bitfield` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `maybe_append_cast` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `maybe_convert_expression_zero_to_null` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `maybe_convert_fixed_array_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `maybe_convert_pointer_type_to_fixed_array_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `maybe_unwrap_bitfield_declaration` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `omit_cpp_functions_visitor` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `omit_unnecessary_typedefs_and_macros` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_get_symbol_names_from_file` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_get_symbol_names_from_file_content` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_get_symbol_names_from_file_fixed_and_cached` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_load_library` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_symbol_exists_in_library` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `parse_call_expression` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `prepend_comment` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_declaration_to_builder` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_enum` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_enum_body` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_expression_to_builder` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_function` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_function_type_to_builder` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_literal_to_builder` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_namespace` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_objc_selector_identifier` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_struct` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_struct_vtable` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_type_to_builder` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_typedef` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `raw_string_from_macro_tokens` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `raw_tokens_string_from_cursor` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `replace_operator_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `run_generator` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `shared_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `should_be_moved_to_global_scope` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `should_be_omitted` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `should_unwrap_typedef` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `size_from_number_flags` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `string_from_macro_value` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `strip_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `stripped_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `to_string` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `try_find_struct_in_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `type_has_name` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `type_to_string` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |


| Implemented generator with remaining paths | Remaining work |
| --- | --- |
| `generate_bindings` | Global POD aggregate/reference C++ declarations execute; namespace/method/overload/custom C++ mapping/printf adapters and broader parsing remain unfinished. |
| `generate_bridge` | Global POD aggregate/reference adapters execute; namespace/method/overload/custom declaration mapping/printf adapters remain unfinished. |

| Native function | Evidence / next check |
| --- | --- |
| `clang_CXIndex_getGlobalOptions` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_CXIndex_setGlobalOptions` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_CXIndex_setInvocationEmissionPathOption` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_CXXField_isMutable` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getBinaryOpcode` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getBinaryOpcodeStr` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getBriefCommentText` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getCXXManglings` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getCommentRange` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getGCCAssemblyClobber` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getGCCAssemblyInput` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getGCCAssemblyNumClobbers` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getGCCAssemblyNumInputs` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getGCCAssemblyNumOutputs` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getGCCAssemblyOutput` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getGCCAssemblyTemplate` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getModule` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getNumTemplateArguments` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getObjCDeclQualifiers` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getObjCManglings` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getObjCPropertyAttributes` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getObjCPropertyGetterName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getObjCPropertySetterName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getObjCSelectorIndex` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getReceiverType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getSpellingNameRange` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getStorageClass` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getTemplateArgumentKind` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getTemplateArgumentType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getTemplateArgumentUnsignedValue` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getTemplateArgumentValue` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_getTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_hasAttrs` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isDynamicCall` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isExternalSymbol` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isFunctionInlined` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isGCCAssemblyHasGoto` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isGCCAssemblyVolatile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isMacroBuiltin` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isMacroFunctionLike` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isObjCOptional` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Cursor_isVariadic` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_EnumDecl_isScoped` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_EvalResult_getAsStr` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_IndexAction_create` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_IndexAction_dispose` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Module_getASTFile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Module_getFullName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Module_getName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Module_getNumTopLevelHeaders` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Module_getParent` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Module_getTopLevelHeader` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Module_isSystem` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_PrintingPolicy_dispose` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_PrintingPolicy_getProperty` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_PrintingPolicy_setProperty` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_TargetInfo_dispose` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_TargetInfo_getPointerWidth` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_TargetInfo_getTriple` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getCXXRefQualifier` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getClassType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getModifiedType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getNamedType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getNullability` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getNumObjCProtocolRefs` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getNumObjCTypeArgs` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getNumTemplateArguments` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getObjCEncoding` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getObjCObjectBaseType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getObjCProtocolDecl` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getObjCTypeArg` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getOffsetOf` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getTemplateArgumentAsType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_getValueType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_Type_isTransparentTagTypedef` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_codeCompleteAt` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_codeCompleteGetContainerKind` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_codeCompleteGetContainerUSR` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_codeCompleteGetContexts` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_codeCompleteGetDiagnostic` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_codeCompleteGetNumDiagnostics` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_codeCompleteGetObjCSelector` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_constructUSR_ObjCCategory` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_constructUSR_ObjCClass` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_constructUSR_ObjCIvar` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_constructUSR_ObjCMethod` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_constructUSR_ObjCProperty` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_constructUSR_ObjCProtocol` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_createTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_createTranslationUnit2` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_createTranslationUnitFromSourceFile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_defaultCodeCompleteOptions` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_defaultEditingTranslationUnitOptions` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_defaultReparseOptions` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_defaultSaveOptions` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_disposeCXPlatformAvailability` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_disposeCXTUResourceUsage` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_disposeCodeCompleteResults` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_disposeDiagnosticSet` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_disposeOverriddenCursors` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_disposeSourceRangeList` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_disposeStringSet` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_enableStackTraces` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_equalTypes` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_executeOnThread` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_findIncludesInFile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_findReferencesInFile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getAddressSpace` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getAllSkippedRanges` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getBinaryOperatorKindSpelling` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getBuildSessionTimestamp` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCXTUResourceUsage` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCXXAccessSpecifier` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCanonicalCursor` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getChildDiagnostics` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getClangVersion` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionAnnotation` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionAvailability` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionBriefComment` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionChunkCompletionString` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionChunkKind` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionChunkText` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionFixIt` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionNumAnnotations` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionNumFixIts` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionParent` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCompletionPriority` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorBinaryOperatorKind` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorCompletionString` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorDisplayName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorExceptionSpecificationType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorKindSpelling` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorLexicalParent` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorPlatformAvailability` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorPrettyPrinted` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorPrintingPolicy` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorReferenceNameRange` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorReferenced` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorResultType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorUSR` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getCursorUnaryOperatorKind` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDeclObjCTypeEncoding` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDefinitionSpellingAndExtent` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDiagnosticCategory` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDiagnosticCategoryName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDiagnosticCategoryText` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDiagnosticInSet` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDiagnosticOption` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getDiagnosticSetFromTU` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getElementType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getExceptionSpecificationType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getFullyQualifiedName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getFunctionTypeCallingConv` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getIBOutletCollectionType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getIncludedFile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getInclusions` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getModuleForFile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getNonReferenceType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getNumCompletionChunks` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getNumDiagnosticsInSet` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getNumElements` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getNumOverloadedDecls` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getOffsetOfBase` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getOverloadedDecl` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getOverriddenCursors` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getRemappings` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getRemappingsFromFileList` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getSkippedRanges` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getSpecializedCursorTemplate` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getTUResourceUsageName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getTemplateCursorKind` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getToken` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getTranslationUnitSpelling` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getTranslationUnitTargetInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getTypeKindSpelling` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getTypePrettyPrinted` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getTypedefName` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getUnaryOperatorKindSpelling` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_getUnqualifiedType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_hashCursor` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_indexLoc_getCXSourceLocation` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_indexLoc_getFileLocation` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_indexSourceFile` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_indexSourceFileFullArgv` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_indexTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getCXXClassDeclInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getClientContainer` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getClientEntity` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getIBOutletCollectionAttrInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getObjCCategoryDeclInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getObjCContainerDeclInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getObjCInterfaceDeclInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getObjCPropertyDeclInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_getObjCProtocolRefListInfo` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_isEntityObjCContainerKind` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_setClientContainer` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_index_setClientEntity` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isAttribute` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isFileMultipleIncludeGuarded` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isPODType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isPreprocessing` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isRestrictQualifiedType` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isStatement` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isUnexposed` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_isVirtualBase` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_loadDiagnostics` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_parseTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_parseTranslationUnit2FullArgv` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_remap_dispose` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_remap_getFilenames` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_remap_getNumFiles` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_reparseTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_saveTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_sortCodeCompletionResults` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_suspendTranslationUnit` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |
| `clang_toggleCrashRecovery` | Exact reviewed binding, compilation and installed SDK symbol lookup; add an original native invocation fixture |

## Generate_C_Header

0 function names have pending declarations; 0 native function names still lack invocation fixtures.

## Check

3 function names have pending declarations; 0 native function names still lack invocation fixtures.

| Function | Reviewed overload variants | Pending variants | Next work / precise question |
| --- | ---: | ---: | --- |
| `finish_error_checking` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_binding_check_memory_stats` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `verify_elsewhere_binding` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |

## Codex

14 function names have pending declarations; 0 native function names still lack invocation fixtures.

| Function | Reviewed overload variants | Pending variants | Next work / precise question |
| --- | ---: | ---: | --- |
| `communication_proc` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `deinit` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `dump_file` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `finish` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `get` | 2 | 2 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `get_plugin` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `get_short_string` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `init` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `log_help` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `make_help` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `message` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `put` | 2 | 2 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `put_short_string` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |
| `shutdown` | 1 | 1 | Reviewed v2 wire/metrics/plugin semantics resolved; implementation pending. Question2 retains exact allocator recognition details |


| Implemented function with remaining paths | Remaining work |
| --- | --- |
| `collect_metrics` | Conditional weights and Basic allocator names await question2, with explicit rejection; calls/identity/assignments/globals/loop depth execute. |

## Debug

20 function names have pending declarations; 0 native function names still lack invocation fixtures.

| Function | Reviewed overload variants | Pending variants | Next work / precise question |
| --- | ---: | ---: | --- |
| `attach_to_debugger` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `break_assert` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `break_once` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `disable_signal_handler` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `enable_signal_handler` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_written_minidump_filename` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `init` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `init_crash_handler_thread` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `interactive_assert` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `no_assert` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_attach_to_debugger` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_disable_signal_handler` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_enable_signal_handler` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_logger` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `os_show_assert_dialog` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `print_assert` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `set_minidump_state` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `set_report_mode` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `trace_assert` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `write_minidump` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |

## Debug_Info

25 function names have pending declarations; 0 native function names still lack invocation fixtures.

| Function | Reviewed overload variants | Pending variants | Next work / precise question |
| --- | ---: | ---: | --- |
| `copy_and_truncate_blocks` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `decode_inline_site_line_info` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `describe_builtin` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `describe_id_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `describe_type` | 2 | 2 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `dump_codeview_types` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `ensure_room` | 1 | 1 | Question14: active-word/capacity, growth, rover and fill policy; already-sized bit operations execute against native PDB/SDK FPM oracles |
| `get_filename` | 1 | 1 | Debug_Info question8: file/directory indexing and path text |
| `get_filename_for_file_id` | 2 | 1 | Debug_Info question8 for DWARF overload; CodeView implementation pending |
| `get_id_type` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `get_type` | 2 | 1 | CodeView overloads pending; canonical DWARF Compilation_Unit offset lookup is implemented/tested |
| `init` | 1 | 1 | Question14: active-word/capacity, growth, rover and fill policy; already-sized bit operations execute against native PDB/SDK FPM oracles |
| `is_procedure` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `is_valid_user_stream_number` | 1 | 1 | Reviewed MSF/UPN/UNSN shapes resolved; canonical integration pending. Question7 retains parameter policies/PDB map shape and user-stream bounds |
| `overlay_inlinesite` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `overlay_inlinesites` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `parse_codeview_symbols` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `parse_codeview_types` | 1 | 1 | Implementation pending; reviewed declarations are available. Check linked questions before choosing unspecified behavior. |
| `parse_compilation_unit_v4` | 1 | 1 | Reviewed Parse_Context and Declaration.kind resolved; canonical DWARF parser implementation pending |
| `parse_dwarf_debug_info` | 1 | 1 | Reviewed canonical parser dependencies resolved; implementation pending |
| `parse_msf` | 1 | 1 | Reviewed MSF/UPN/UNSN shapes resolved; canonical integration pending. Question7 retains parameter policies/PDB map shape and user-stream bounds |
| `parse_pdb` | 1 | 1 | Reviewed MSF/UPN/UNSN shapes resolved; canonical integration pending. Question7 retains parameter policies/PDB map shape and user-stream bounds |
| `parse_tpi_stream` | 1 | 1 | Reviewed MSF/UPN/UNSN shapes resolved; canonical integration pending. Question7 retains parameter policies/PDB map shape and user-stream bounds |
| `set_all` | 1 | 1 | Question14: active-word/capacity, growth, rover and fill policy; already-sized bit operations execute against native PDB/SDK FPM oracles |
| `verify_integrity` | 1 | 1 | Reviewed MSF/UPN/UNSN shapes resolved; canonical integration pending. Question7 retains parameter policies/PDB map shape and user-stream bounds |


| Implemented map helper with remaining paths | Remaining work |
| --- | --- |
| `is_free_page` | Initialized in-range words execute; capacity/active-word policy awaits question14. |
| `alloc_page` | In-range allocation bits execute; automatic growth and rover policy await question14. |
| `free_page` | In-range free bits execute; automatic growth and rover policy await question14. |
| `is_fpm_page_number` | MSF7 4096-byte big-map positions execute; other layouts remain unsupported. |

## Print_Vars

0 function names have pending declarations; 0 native function names still lack invocation fixtures.

## Iprof

41 function names have pending declarations; 0 native function names still lack invocation fixtures.

| Function | Reviewed overload variants | Pending variants | Next work / precise question |
| --- | ---: | ---: | --- |
| `Automatic_Zone` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `Automatic_Zone_Guarded` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `Prof_init_highlevel` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `add_hook` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `add_source` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `before_intercept` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `clear_stack` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `compute_heat` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `createStackNode` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `create_report` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `draw` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `draw_graph` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `eternity_set` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `finish` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `get_current_graph_scaling` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `get_plugin` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `graph_select_sample` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `hash` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `init` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `init_zone_hash` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `insert_node` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `log_help` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `message` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `move_cursor` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `move_frame` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `propagate_expanded` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `propagate_stack` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `propagate_to_zone` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `report_compare_slot` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `report_expand_compare` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `select` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `select_parent` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `set_cursor` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `set_cursor_screen_coordinates` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `set_frame` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `set_report_mode` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `shutdown` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `sum_times` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `traverse` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `update` | 2 | 2 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |
| `update_history` | 1 | 1 | Reviewed instrumentation/history/report/options refinements available; implementation pending, with remaining calibration/recursion precision in question2 |

## Performance_Report

0 function names have pending declarations; 0 native function names still lack invocation fixtures.

## Rewrite

0 function names have pending declarations; 0 native function names still lack invocation fixtures.
