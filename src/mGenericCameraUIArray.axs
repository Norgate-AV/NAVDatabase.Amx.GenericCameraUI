MODULE_NAME='mGenericCameraUIArray'     (
                                            dev dvTP[],
                                            dev vdvObject
                                        )

(***********************************************************)
#include 'NAVFoundation.ModuleBase.axi'
#include 'NAVFoundation.UIUtils.axi'
#include 'NAVFoundation.ArrayUtils.axi'

/*
 _   _                       _          ___     __
| \ | | ___  _ __ __ _  __ _| |_ ___   / \ \   / /
|  \| |/ _ \| '__/ _` |/ _` | __/ _ \ / _ \ \ / /
| |\  | (_) | | | (_| | (_| | ||  __// ___ \ V /
|_| \_|\___/|_|  \__, |\__,_|\__\___/_/   \_\_/
                 |___/

MIT License

Copyright (c) 2023 Norgate AV Services Limited

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile integer iPresetHeld

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START {

}
(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT
button_event[dvTP, 0] {
    push: {
    switch (button.input.channel) {
        case TILT_UP:
        case TILT_DN:
        case PAN_LT:
        case PAN_RT:
        case ZOOM_IN:
        case ZOOM_OUT:
        case FOCUS_NEAR:
        case FOCUS_FAR:
        case AUTO_FOCUS: {
        to[vdvObject, button.input.channel]
        }
    }
    }
    hold[20]: {
    switch (button.input.channel) {
        case TILT_UP:
        case TILT_DN:
        case PAN_LT:
        case PAN_RT:
        case ZOOM_IN:
        case ZOOM_OUT: {
        //send_level vdvObject, TILT_SPEED_LVL, 30
        //send_level vdvObject, PAN_SPEED_LVL, 30
        //send_level vdvObject, ZOOM_SPEED_LVL, 15
        }
        case NAV_PRESET_1:
        case NAV_PRESET_2:
        case NAV_PRESET_3:
        case NAV_PRESET_4:
        case NAV_PRESET_5:
        case NAV_PRESET_6:
        case NAV_PRESET_7:
        case NAV_PRESET_8: {
        iPresetHeld = true
        NAVBeepArray(dvTP)
        NAVCommand(vdvObject, "'PRESETSAVE-', itoa(NAVFindInArrayINTEGER(NAV_PRESET, button.input.channel))")
        }
    }
    }
    release: {
    switch (button.input.channel) {
        case TILT_UP:
        case TILT_DN:
        case PAN_LT:
        case PAN_RT:
        case ZOOM_IN:
        case ZOOM_OUT: {
        //send_level vdvObject, TILT_SPEED_LVL, 20
        //send_level vdvObject, PAN_SPEED_LVL, 20
        //send_level vdvObject, ZOOM_SPEED_LVL, 10
        }
        case NAV_PRESET_1:
        case NAV_PRESET_2:
        case NAV_PRESET_3:
        case NAV_PRESET_4:
        case NAV_PRESET_5:
        case NAV_PRESET_6:
        case NAV_PRESET_7:
        case NAV_PRESET_8: {
        if (!iPresetHeld) {
            NAVCommand(vdvObject, "'PRESET-', itoa(NAVFindInArrayINTEGER(NAV_PRESET, button.input.channel))")
        }

        iPresetHeld = false
        }
    }
    }
}


timeline_event[TL_NAV_FEEDBACK] {
    [dvTP, AUTO_FOCUS] = ([vdvObject, AUTO_FOCUS_FB])
}


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

