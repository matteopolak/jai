// Staged lifecycle candidate consumer; activate only with its draft source.
#import "Basic";
#import "Hash_Table";
B :: #import "Bindings_Generator";
P :: #import "Pool";

main :: () {
    pool: P.Pool;
    pool.alignment = 16;
    P.set_allocators(*pool);
    defer P.release(*pool);

    push_context {
        context.allocator = .{ P.pool_allocator_proc, *pool };
        generator: B.Generator;
        options: B.Generate_Bindings_Options;

        array_add(*options.source_files, tprint("%bindings-input.h", #filepath));
        array_add(*options.libraries, B.Library.{ filename = "developer_tools_binding", identifier = "native" });
        B.init_generator(*generator, options);
        assert(context.generator == *generator);
        assert(generator.type_def_s32.size == 4 && generator.type_def_u64.size == 8);
        assert(generator.type_def_pointer_to_void.pointer_to == generator.type_def_void);
        assert(B.run_generator(*generator, options));
        assert(context.generator == *generator);
        assert(generator.pointer_size == 8 && generator.clang_index != null && generator.translation_unit != null);
        assert(generator.global_scope.members.count > 0);
        assert(generator.counts.structs > 0 && generator.counts.functions > 0);
        found_record := false;

        for declaration: generator.global_scope.members {
            if declaration.kind == .STRUCT {
                found_record = true;
                assert(declaration.type.type_of_struct == cast(*B.Struct) declaration);
            }

            if declaration.kind == .FUNCTION assert(declaration.type.type_of_function != null);
        }

        assert(found_record);
        assert(generator.declarations_by_cursor.count > 0);
        B.deinit_generator(*generator);
        assert(context.generator == *generator);
        assert(generator.translation_unit == null && generator.clang_index == null);
        B.deinit_generator(*generator);
    }

    print("ok\n");
}
