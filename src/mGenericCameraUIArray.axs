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

constant integer AUTO_TRACK_ON  = 301
constant integer AUTO_TRACK_OFF = 302
constant integer AUTO_TRACK_FB  = 331

constant integer AUTO_TRACK_ANGLE_FULL  = 311
constant integer AUTO_TRACK_ANGLE_UPPER = 312
constant integer AUTO_TRACK_ANGLE_OFF   = 313

constant integer AUTO_TRACK_ANGLE_FULL_FB  = 341
constant integer AUTO_TRACK_ANGLE_UPPER_FB = 342
constant integer AUTO_TRACK_ANGLE_OFF_FB   = 343


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

volatile char iPresetHeld = false

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

define_function UpdateFeedback() {
    [dvTP, AUTO_FOCUS] = ([vdvObject, AUTO_FOCUS_FB])
    [dvTP, AUTO_TRACK_ON] = ([vdvObject, AUTO_TRACK_FB])
    [dvTP, AUTO_TRACK_OFF] = (![vdvObject, AUTO_TRACK_FB])
    [dvTP, AUTO_TRACK_ANGLE_FULL] = ([vdvObject, AUTO_TRACK_ANGLE_FULL_FB])
    [dvTP, AUTO_TRACK_ANGLE_UPPER] = ([vdvObject, AUTO_TRACK_ANGLE_UPPER_FB])
    [dvTP, AUTO_TRACK_ANGLE_OFF] = ([vdvObject, AUTO_TRACK_ANGLE_OFF_FB])
}


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
            case AUTO_TRACK_ON: {
                NAVCommand(vdvObject, "'AUTOTRACK-ON'")
                NAVCommand(vdvObject, "'AUTOTRACK-START'")
            }
            case AUTO_TRACK_OFF: {
                // NAVCommand(vdvObject, "'AUTOTRACK-STOP'")
                NAVCommand(vdvObject, "'AUTOTRACK-OFF'")
            }
            case AUTO_TRACK_ANGLE_FULL: {
                NAVCommand(vdvObject, "'AUTOTRACK_ANGLE-FULL'")
            }
            case AUTO_TRACK_ANGLE_UPPER: {
                NAVCommand(vdvObject, "'AUTOTRACK_ANGLE-UPPER'")
            }
            case AUTO_TRACK_ANGLE_OFF: {
                NAVCommand(vdvObject, "'AUTOTRACK_ANGLE-OFF'")
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
                // send_level vdvObject, TILT_SPEED_LVL, 30
                // send_level vdvObject, PAN_SPEED_LVL, 30
                // send_level vdvObject, ZOOM_SPEED_LVL, 15
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

                NAVCommand(vdvObject,
                            "'PRESETSAVE-', itoa(NAVFindInArrayINTEGER(NAV_PRESET,
                                                                        button.input.channel))")
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
                // send_level vdvObject, TILT_SPEED_LVL, 20
                // send_level vdvObject, PAN_SPEED_LVL, 20
                // send_level vdvObject, ZOOM_SPEED_LVL, 10
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
                    NAVCommand(vdvObject,
                                "'PRESET-', itoa(NAVFindInArrayINTEGER(NAV_PRESET,
                                                                        button.input.channel))")
                }

                iPresetHeld = false
            }
        }
    }
}


channel_event[vdvObject, AUTO_FOCUS_FB]
channel_event[vdvObject, AUTO_TRACK_FB]
channel_event[vdvObject, AUTO_TRACK_ANGLE_FULL_FB]
channel_event[vdvObject, AUTO_TRACK_ANGLE_UPPER_FB]
channel_event[vdvObject, AUTO_TRACK_ANGLE_OFF_FB] {
    on: {
        UpdateFeedback()
    }
    off: {
        UpdateFeedback()
    }
}


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)
