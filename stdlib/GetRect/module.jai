// Right-handed (y-up) GetRect: the standard GetRect module API.
// Shared implementation lives in ../GetRect_Common; see docs/stdlib/getrect.md.
#module_parameters ()(Type_Indicator: Type = void);
Math :: #import "Math";
#import "Math";
Basic :: #import "Basic";
#scope_module
GETRECT_Y_UP :: true;
#scope_export
#load "../GetRect_Common/geometry.jai";
#load "../GetRect_Common/geometry-helpers.jai";
#load "../GetRect_Common/ui.jai";
