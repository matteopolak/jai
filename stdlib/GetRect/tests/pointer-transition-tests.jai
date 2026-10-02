// Calls the actual production transition; there are no renderer/platform stubs.
#load "../interaction.jai";
pointer_transition_cases :: () -> bool {
    state:=ui_pointer_activation(false,true,true,false,true);
    if !state.capture||state.clicked return false;
    state=ui_pointer_activation(state.capture,true,false,false,true);
    if !state.capture||state.clicked return false;
    state=ui_pointer_activation(state.capture,true,false,true,true);
    if state.capture||!state.clicked return false;
    state=ui_pointer_activation(false,false,true,false,true);
    if state.capture||state.clicked return false;
    state=ui_pointer_activation(true,false,false,true,true);
    if state.capture||state.clicked return false;
    state=ui_pointer_activation(false,true,true,false,false);
    if state.capture||state.clicked return false;
    state=ui_pointer_activation(false,true,true,true,true);
    if state.capture||!state.clicked return false;
    return true;
}
#assert #run pointer_transition_cases();
main :: () { pointer_transition_cases(); }
