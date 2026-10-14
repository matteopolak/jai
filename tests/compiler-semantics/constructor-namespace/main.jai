R :: #import "Record";
F :: #import "Factory";

#assert R.Buffer == R.Alias;
#assert R.Buffer != F.Buffer;
#assert type_of(R.create()) == *R.Alias;

#program_export "namespace_check"
check :: () -> s32 #c_call {
    push_context {
        value := R.create();
        if value.value != 37 || value.next != null return 1;

        value.next = value;
        again := R.create();
        if again != value || again.value != 37 || again.next != null return 2;
    }

    return 0;
}
