G :: #import "GetRect_LeftHanded";
text_interaction_cases :: ()->bool {
    if G.seek_left_one_word("one two",7)!=4||G.seek_right_one_word("one two",0)!=4 return false;
    state:G.Text_Input_State; G.set_input(*state,"one two"); G.move_cursor_left_by_word(*state,true);
    if G.get_selection(*state)!="two" return false;
    G.replace_selection(*state,"three"); if state.text!="one three" return false;
    G.backspace_from_cursor(*state,true); if state.text!="one " return false;
    return true;
}
#assert #run text_interaction_cases();
main :: () { text_interaction_cases(); }
