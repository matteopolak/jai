#scope_module
UI_Activation_Result :: struct { capture: bool; clicked: bool; }
// Shared production transition, separated from window/drawing dependencies.
ui_pointer_activation :: (captured: bool, over: bool, press: bool, release: bool, enabled: bool) -> UI_Activation_Result {
    result:=UI_Activation_Result.{capture=captured};
    if enabled && over && press result.capture=true;
    if result.capture && release { result.capture=false; result.clicked=over; }
    return result;
}
