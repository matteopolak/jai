// Independently authored packed vectors; maintained storage has no extra fields.
Table :: struct ($K: Type, $V: Type) {
    keys: [..]K;
    values: [..]V;
    count: int;
}
init :: (table:*Table($K,$V),capacity:=0) {
    table_ensure_space(table,Basic.max(0,capacity-table.keys.count));
    table.count=table.keys.count;
}
deinit :: (table:*Table($K,$V)) {
    Basic.array_reset(*table.keys); Basic.array_reset(*table.values);
    table.count=0;
}
table_add :: (table:*Table($K,$V),key:K,value:V) {
    position:=_find_index(table,key);
    if position<0 _append_entry(table,key,value);
    else table.values[position]=value;
}
table_set :: (table:*Table($K,$V),key:K,value:V) { table_add(table,key,value); }
table_find :: (table:*Table($K,$V),key:K)->V,bool {
    position:=_find_index(table,key);
    if position>=0 return table.values[position],true;
    empty:V;
    return empty,false;
}
table_find_pointer :: (table:*Table($K,$V),key:K)->*V {
    position:=_find_index(table,key);
    if position<0 return null;
    return table.values.data+position;
}
table_contains :: (table:*Table($K,$V),key:K)->bool { return _find_index(table,key)>=0; }
table_remove :: (table:*Table($K,$V),key:K)->bool,V {
    position:=_find_index(table,key);
    empty:V;
    if position<0 return false,empty;
    saved:=table.values[position];
    _remove_at(table,position);
    return true,saved;
}
// Additional historical callable helpers use the maintained storage layout.
resize :: (table:*Table($K,$V),slots_to_allocate:s64=0) {
    table_ensure_space(table,Basic.max(0,slots_to_allocate-table.count));
}
table_reset :: (table:*Table($K,$V)) {
    table.keys.count=0; table.values.count=0; table.count=0;
}
table_ensure_space :: (table:*Table($K,$V),items:s64) {
    Basic.assert(items>=0);
    Basic.array_reserve(*table.keys,table.keys.count+items);
    Basic.array_reserve(*table.values,table.values.count+items);
}
table_add_duplicate :: (table:*Table($K,$V),key:K,value:V)->*V { return _append_entry(table,key,value); }
table_find_multiple :: (table:*Table($K,$V),key:K)->[]V {
    result:[..]V; result.allocator=Basic.temp;
    for index:0..table.count-1 if table.keys[index]==key Basic.array_add(*result,table.values[index]);
    return result;
}
find_or_add :: (table:*Table($K,$V),key:K)->(entry:*V,newly_added:bool) {
    pointer:=table_find_pointer(table,key);
    if pointer return pointer,false;
    zero:V;
    return _append_entry(table,key,zero),true;
}
for_expansion :: (table:*$T/Table,body:Code,flags:For_Flags) #expand {
    cursor:=0;
    #if flags&.REVERSE cursor=table.count-1;
    while cursor>=0 && cursor<table.count {
        #if flags&.POINTER { `it:=table.values.data+cursor; }
        else { `it:=table.values[cursor]; }
        `it_index:=table.keys[cursor];
        #insert (remove={_remove_at(table,cursor); #if !(flags&.REVERSE) cursor-=1;}) body;
        #if flags&.REVERSE cursor-=1;
        else cursor+=1;
    }
}
NEVER_OCCUPIED_HASH :: 0;
REMOVED_HASH :: 1;
FIRST_VALID_HASH :: 2;
expand :: (table:*Table($K,$V)) {
    resize(table,Basic.max(32,Basic.max(table.keys.allocated,table.values.allocated)*2));
}
next_power_of_two :: (x:int)->int { n:=1; while n<x n*=2; return n; }
#scope_file
Basic :: #import "Basic";
_find_index :: (table:*Table($K,$V),key:K)->int {
    cursor:=table.keys.count;
    while cursor>0 {
        cursor-=1;
        if table.keys[cursor]==key return cursor;
    }
    return -1;
}
_append_entry :: (table:*Table($K,$V),key:K,value:V)->*V {
    position:=table.keys.count;
    table_ensure_space(table,1);
    table.keys.data[position]=key;
    table.values.data[position]=value;
    table.keys.count=position+1; table.values.count=position+1;
    table.count=position+1;
    return table.values.data+position;
}
_remove_at :: (table:*Table($K,$V),index:int) {
    Basic.assert(index>=0 && index<table.count);
    remaining:=table.count-index-1;
    cursor:=0;
    while cursor<remaining {
        table.keys[index+cursor]=table.keys[index+cursor+1];
        table.values[index+cursor]=table.values[index+cursor+1];
        cursor+=1;
    }
    table.keys.count-=1; table.values.count-=1;
    table.count=table.keys.count;
}
