// Hierarchy weights and independent squarified display rectangles.
#scope_file;
#import "Basic";
#import "Math";
Buckets :: #import "Bucket_Array";
#scope_export;

Border_Direction :: enum u8 {
    EAST :: 0;
    NORTH :: 1;
    WEST :: 2;
    SOUTH :: 3;
}

Display_Node :: struct {
    corner: Vector2;
    size: Vector2;
    border: [4] float;
    node: *Treemap_Node;
}

Treemap_Display :: struct {
    nodes: [..] Display_Node;
    treemap: *Treemap;
    outer_size: Vector2;
    dirty := true;
}

Treemap_Node :: struct {
    name: string;
    size: float64;
    parent: *Treemap_Node;
    children: [..] *Treemap_Node;
    user_data_pointer: *void;
    user_data_s64: s64;
    user_data_float64: float64;
    locator: Buckets.Bucket_Locator;
}

Treemap :: struct {
    nodes: Buckets.Bucket_Array(Treemap_Node, 1024);
    root: *Treemap_Node;
    dirty := true;
}

Border_Proc :: #type (corner: Vector2, outer_dimensions: Vector2, node: *Treemap_Node, parent: *Display_Node, border_values: *[4] float);

add_node :: (treemap: *Treemap, name: string, parent: *Treemap_Node) -> *Treemap_Node {
    assert(treemap != null);
    if treemap.root {
        assert(parent != null);
        index := get_index(treemap, parent);
        assert(index >= 0 && index < treemap.nodes.count);
        assert(*treemap.nodes.all_buckets[index / 1024].data[index % 1024] == parent);
    } else assert(parent == null);
    fresh: Treemap_Node;
    fresh.name = name;
    fresh.parent = parent;
    locator, node := Buckets.bucket_array_add(*treemap.nodes, fresh);
    node.locator = locator;
    if parent array_add(*parent.children, node);
    else treemap.root = node;
    treemap.dirty = true;
    return node;
}

recompute_if_dirty :: (treemap: *Treemap) {
    if !treemap.dirty return;
    if treemap.root recompute_sizes(treemap.root);
    state := tree_state_index(treemap);
    tree_states[state].generation += 1;
    treemap.dirty = false;
}

init_treemap_display :: (treemap: *Treemap) -> Treemap_Display {
    display: Treemap_Display;
    display.treemap = treemap;
    return display;
}

recompute_if_dirty :: (display: *Treemap_Display, outer_size: Vector2, border_proc: Border_Proc = null, force := false) {
    assert(display.treemap != null && outer_size.x >= 0 && outer_size.y >= 0);
    treemap := display.treemap;
    recompute_if_dirty(treemap);
    tree_state := tree_state_index(treemap);
    state := display_state_index(display);
    generation := tree_states[tree_state].generation;
    if !force && !display.dirty && display_states[state].tree == treemap && display_states[state].generation == generation && display_states[state].data == display.nodes.data && display_states[state].border_proc == border_proc && display.nodes.count == treemap.nodes.count && display.outer_size.x == outer_size.x && display.outer_size.y == outer_size.y return;
    array_reset(*display.nodes);
    for index: 0..treemap.nodes.count - 1 {
        bucket := treemap.nodes.all_buckets[index / 1024];
        assert(bucket.occupied[index % 1024]);
        record: Display_Node;
        record.node = *bucket.data[index % 1024];
        array_add(*display.nodes, record);
    }
    display.outer_size = outer_size;
    if treemap.root {
        root_index := get_index(treemap, treemap.root);
        display.nodes[root_index].size = outer_size;
        size_children(treemap, treemap.root, display, border_proc);
    }
    display_states[state].tree = treemap;
    display_states[state].generation = generation;
    display_states[state].data = display.nodes.data;
    display_states[state].border_proc = border_proc;
    display.dirty = false;
}

size_children :: (treemap: *Treemap, root: *Treemap_Node, display: *Treemap_Display, border_proc: Border_Proc) {
    record := *display.nodes[get_index(treemap, root)];
    record.border = .{};
    parent: *Display_Node;
    if root.parent parent = *display.nodes[get_index(treemap, root.parent)];
    if border_proc border_proc(record.corner, record.size, root, parent, *record.border);
    for *record.border {
        if <<it < 0 {
            <<it = 0;
        }
    }
    corner := record.corner;
    corner.x += record.border[2];
    corner.y += record.border[1];
    remaining := record.size;
    remaining.x -= record.border[0] + record.border[2];
    remaining.y -= record.border[1] + record.border[3];
    if remaining.x < 0 remaining.x = 0;
    if remaining.y < 0 remaining.y = 0;
    weight_left := root.size;
    first: int = 0;
    while first < root.children.count {
        if weight_left <= 0 || root.children[first].size <= 0 {
            for i: first..root.children.count - 1 {
                child_record := *display.nodes[get_index(treemap, root.children[i])];
                child_record.corner = corner;
                child_record.size = .{};
            }
            break;
        }
        area_per_weight := cast(float64) remaining.x * cast(float64) remaining.y / weight_left;
        short_side := cast(float64) remaining.x;
        if remaining.y < remaining.x short_side = cast(float64) remaining.y;
        last := first + 1;
        group_weight := root.children[first].size;
        largest := group_weight;
        smallest := group_weight;
        score := row_score(group_weight, largest, smallest, short_side, area_per_weight);
        while last < root.children.count {
            next_weight := root.children[last].size;
            candidate := row_score(group_weight + next_weight, largest, next_weight, short_side, area_per_weight);
            if candidate > score break;
            group_weight += next_weight;
            smallest = next_weight;
            score = candidate;
            last += 1;
        }
        horizontal := remaining.x <= remaining.y;
        fraction := group_weight / weight_left;
        if fraction > 1 fraction = 1;
        strip := remaining;
        if horizontal strip.y = cast(float) (cast(float64) remaining.y * fraction);
        else strip.x = cast(float) (cast(float64) remaining.x * fraction);
        flush_nodes(root.children, first, last, display, corner, group_weight, horizontal, strip);
        if horizontal {
            corner.y += strip.y;
            remaining.y -= strip.y;
        } else {
            corner.x += strip.x;
            remaining.x -= strip.x;
        }
        weight_left -= group_weight;
        first = last;
    }
    for root.children size_children(treemap, it, display, border_proc);
}

// The row range is [unsized_cursor, child_index), including an empty range.
flush_nodes :: (children: [] *Treemap_Node, unsized_cursor: int, child_index: int, display: *Treemap_Display, root_corner: Vector2, fill_weight_total: float64, horizontal: bool, size: Vector2) -> (flushed_node_weight: float64) {
    assert(unsized_cursor >= 0 && child_index >= unsized_cursor && child_index <= children.count);
    result: float64;
    cursor := root_corner;
    for i: unsized_cursor..child_index - 1 {
        child := children[i];
        record := *display.nodes[get_index(display.treemap, child)];
        fraction: float64;
        if fill_weight_total > 0 fraction = child.size / fill_weight_total;
        record.corner = cursor;
        record.size = size;
        if horizontal {
            record.size.x = cast(float) (cast(float64) size.x * fraction);
            if i == child_index - 1 record.size.x = root_corner.x + size.x - cursor.x;
            cursor.x += record.size.x;
        } else {
            record.size.y = cast(float) (cast(float64) size.y * fraction);
            if i == child_index - 1 record.size.y = root_corner.y + size.y - cursor.y;
            cursor.y += record.size.y;
        }
        result += child.size;
    }
    return result;
}

get_index :: (treemap: *Treemap, node: *Treemap_Node) -> s64 {
    assert(node != null);
    return cast(s64) node.locator.bucket_index * treemap.nodes.items_per_bucket + node.locator.slot_index;
}

// These helpers also retire private cache state for the supplied owner address.
free_treemap_display :: (display: *Treemap_Display) {
    if !display return;
    array_free(display.nodes);
    display.nodes = .{};
    display.dirty = true;
    index: int = 0;
    while index < display_states.count {
        if display_states[index].display == display array_unordered_remove_by_index(*display_states, index);
        else index += 1;
    }
    if display_states.count == 0 {
        array_free(display_states);
        display_states = .{};
    }
}

free_treemap :: (treemap: *Treemap) {
    if !treemap return;
    for treemap.nodes.all_buckets {
        bucket := it;
        for slot: 0..treemap.nodes.items_per_bucket - 1 {
            if bucket.occupied[slot] array_free(bucket.data[slot].children);
        }
    }
    Buckets.bucket_array_reset(*treemap.nodes);
    treemap.root = null;
    treemap.dirty = true;
    index: int = 0;
    while index < tree_states.count {
        if tree_states[index].tree == treemap array_unordered_remove_by_index(*tree_states, index);
        else index += 1;
    }
    index = 0;
    while index < display_states.count {
        if display_states[index].tree == treemap array_unordered_remove_by_index(*display_states, index);
        else index += 1;
    }
    if tree_states.count == 0 {
        array_free(tree_states);
        tree_states = .{};
    }
    if display_states.count == 0 {
        array_free(display_states);
        display_states = .{};
    }
}

#scope_file;

Tree_State :: struct {
    tree: *Treemap;
    generation: s64;
}
Display_State :: struct {
    display: *Treemap_Display;
    tree: *Treemap;
    generation: s64 = -1;
    data: *Display_Node;
    border_proc: Border_Proc;
}
tree_states: [..] Tree_State;
display_states: [..] Display_State;

tree_state_index :: (tree: *Treemap) -> int {
    for tree_states if it.tree == tree return it_index;
    tree_states.allocator = context.default_allocator;
    record: Tree_State;
    record.tree = tree;
    array_add(*tree_states, record);
    return tree_states.count - 1;
}

display_state_index :: (display: *Treemap_Display) -> int {
    for display_states if it.display == display return it_index;
    display_states.allocator = context.default_allocator;
    record: Display_State;
    record.display = display;
    record.tree = display.treemap;
    array_add(*display_states, record);
    return display_states.count - 1;
}

recompute_sizes :: (node: *Treemap_Node) {
    if node.children.count == 0 {
        if node.size < 0 node.size = 0;
        return;
    }
    node.size = 0;
    for node.children {
        recompute_sizes(it);
        node.size += it.size;
    }
    for index: 1..node.children.count - 1 {
        child := node.children[index];
        cursor := index;
        while cursor > 0 && node.children[cursor - 1].size < child.size {
            node.children[cursor] = node.children[cursor - 1];
            cursor -= 1;
        }
        node.children[cursor] = child;
    }
}

row_score :: (total: float64, largest: float64, smallest: float64, side: float64, scale: float64) -> float64 {
    if smallest <= 0 || side <= 0 || scale <= 0 return 1.0e300;
    squared_side := side * side;
    squared_total := total * total;
    a := squared_side * largest / (scale * squared_total);
    b := scale * squared_total / (squared_side * smallest);
    if a > b return a;
    return b;
}
