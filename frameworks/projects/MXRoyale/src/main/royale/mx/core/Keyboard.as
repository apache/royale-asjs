////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package mx.core
{
COMPILE::SWF
{
    import flash.ui.Keyboard;
}

	/**
	 *  This class holds constants for special keys
	 *  See: 
	 *  See: 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Keyboard
	{
        private static var _capsLock:Boolean;
        
        COMPILE::JS
        public static function setCapsLock(value:Boolean):void
        {
            _capsLock = value;
        }
        
        public static function get capsLock():Boolean
        {
            COMPILE::SWF
            {
                _capsLock = flash.ui.Keyboard.capsLock;
            }
            return _capsLock;
        }
		
		/***
		 * [static] Constant associated with the key code value for the A key (65).
		 */
		
		public static const A : uint = 65;
		
		/**
		 * [static] Constant associated with the key code value for the Alternate (Option) key (18).
		 */
		public static const ALTERNATE : uint = 18;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for selecting the audio mode.
		 */
		public static const AUDIO : uint = 0x01000017;
		
		
		/**
		 * [static] Constant associated with the key code value for the B key (66).
		 */
		public static const B : uint = 66;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for returning to the previous page in the application.
		 */
		public static const BACK : uint = 0x01000016;
		
		
		/**
		 * [static] Constant associated with the key code value for the ` key (192).
		 */
		public static const BACKQUOTE : uint = 192;
		
		
		/**
		 * [static] Constant associated with the key code value for the &#92; key (220).
		 */
		public static const BACKSLASH : uint = 220;
		
		
		/**
		 * [static] Constant associated with the key code value for the Backspace key (8).
		 */
		public static const BACKSPACE : uint = 8;
		
		
		/**
		 * [static] Constant associated with the key code value for the blue function key button.
		 */
		public static const BLUE : uint = 0x01000003;
		
		
		/**
		 * [static] Constant associated with the key code value for the C key (67). 
		 */
		public static const C : uint = 67;
		
		
		/**
		 * [static] Constant associated with the key code value for the Caps Lock key (20).
		 */
		public static const CAPS_LOCK : uint = 20;
		
		
		/**
		 * [static] Constant associated with the key code value for the channel down button.
		 */
		public static const CHANNEL_DOWN : uint = 0x01000005;
		
		
		/**
		 * [static] Constant associated with the key code value for the channel up button.
		 */
		public static const CHANNEL_UP : uint = 0x01000004;
		
		
		/**
		 * [static] An array containing all the defined key name constants. 
		 */
		public static const CharCodeStrings : Array = null;
		
		
		/**
		 * [static] Constant associated with the key code value for the , key (188).
		 */
		public static const COMMA : uint = 188;
		
		
		/**
		 * [static] Constant associated with the Mac command key (15).
		 */
		public static const COMMAND : uint = 15;
		
		
		/**
		 * [static] Constant associated with the key code value for the Control key (17).
		 */
		public static const CONTROL : uint = 17;
		
		
		/**
		 * [static] Constant associated with the key code value for the D key (68).
		 */
		public static const D : uint = 68;
		
		
		/**
		 * [static] Constant associated with the key code value for the Delete key (46).
		 */
		public static const DELETE : uint = 46;
		
		
		/**
		 * [static] Constant associated with the key code value for the Down Arrow key (40).
		 */
		public static const DOWN : uint = 40;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging DVR application mode.
		 */
		public static const DVR : uint = 0x01000019;
		
		
		/**
		 * [static] Constant associated with the key code value for the E key (69).
		 */
		public static const E : uint = 69;
		
		
		/**
		 * [static] Constant associated with the key code value for the End key (35).
		 */
		public static const END : uint = 35;
		
		
		/**
		 * [static] Constant associated with the key code value for the Enter key (13).
		 */
		public static const ENTER : uint = 13;
		
		
		/**
		 * [static] Constant associated with the key code value for the = key (187).
		 */
		public static const EQUAL : uint = 187;
		
		
		/**
		 * [static] Constant associated with the key code value for the Escape key (27).
		 */
		public static const ESCAPE : uint = 27;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for exiting the current application mode.
		 */
		public static const EXIT : uint = 0x01000015;
		
		
		/**
		 * [static] Constant associated with the key code value for the F key (70).
		 */
		public static const F : uint = 70;
		
		
		/**
		 * [static] Constant associated with the key code value for the F1 key (112).
		 */
		public static const F1 : uint = 112;
		
		
		/**
		 * [static] Constant associated with the key code value for the F10 key (121).
		 */
		public static const F10 : uint = 121;
		
		
		/**
		 * [static] Constant associated with the key code value for the F11 key (122).
		 */
		public static const F11 : uint = 122;
		
		
		/**
		 * [static] Constant associated with the key code value for the F12 key (123).
		 */
		public static const F12 : uint = 123;
		
		
		/**
		 * [static] Constant associated with the key code value for the F13 key (124).
		 */
		public static const F13 : uint = 124;
		
		
		/**
		 * [static] Constant associated with the key code value for the F14 key (125).
		 */
		public static const F14 : uint = 125;
		
		
		/**
		 * [static] Constant associated with the key code value for the F15 key (126).
		 */
		public static const F15 : uint = 126;
		
		
		/**
		 * [static] Constant associated with the key code value for the F2 key (113).
		 */
		public static const F2 : uint = 113;
		
		
		/**
		 * [static] Constant associated with the key code value for the F3 key (114).
		 */
		public static const F3 : uint = 114;
		
		
		/**
		 * [static] Constant associated with the key code value for the F4 key (115).
		 */
		public static const F4 : uint = 115;
		
		
		/**
		 * [static] Constant associated with the key code value for the F5 key (116).
		 */
		public static const F5 : uint = 116;
		
		
		/**
		 * [static] Constant associated with the key code value for the F6 key (117).
		 */
		public static const F6 : uint = 117;
		
		
		/**
		 * [static] Constant associated with the key code value for the F7 key (118).
		 */
		public static const F7 : uint = 118;
		
		
		/**
		 * [static] Constant associated with the key code value for the F8 key (119).
		 */
		public static const F8 : uint = 119;
		
		
		/**
		 * [static] Constant associated with the key code value for the F9 key (120).
		 */
		public static const F9 : uint = 120;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging fast-forward transport mode.
		 */
		public static const FAST_FORWARD : uint = 0x0100000A;
		
		
		/**
		 * [static] Constant associated with the key code value for the G key (71).
		 */
		public static const G : uint = 71;
		
		
		/**
		 * [static] Constant associated with the key code value for the green function key button.
		 */
		public static const GREEN : uint = 0x01000001;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging the program guide. 
		 */
		public static const GUIDE : uint = 0x01000014;
		
		
		/**
		 * [static] Constant associated with the key code value for the H key (72).
		 */
		public static const H : uint = 72;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging the help application or context-sensitive help.
		 */
		public static const HELP : uint = 0x0100001D;
		
		
		/**
		 * [static] Constant associated with the key code value for the Home key (36).
		 */
		public static const HOME : uint = 36;
		
		
		/**
		 * [static] Constant associated with the key code value for the I key (73).
		 */
		public static const I : uint = 73;
		
		
		/**
		 * [static] Constant associated with the key code value for the info button.
		 */
		public static const INFO : uint = 0x01000013;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for cycling inputs.
		 */
		public static const INPUT : uint = 0x0100001B;
		
		
		/**
		 * [static] Constant associated with the key code value for the Insert key (45).
		 */
		public static const INSERT : uint = 45;
		
		
		/**
		 * [static] Constant associated with the key code value for the J key (74).
		 */
		public static const J : uint = 74;
		
		
		/**
		 * [static] Constant associated with the key code value for the K key (75).
		 */
		public static const K : uint = 75;
		
		
		/**
		 * [static] The Begin key
		 */
		public static const KEYNAME_BEGIN : String = "Begin";
		
		
		/**
		 * [static] The Break key
		 */
		public static const KEYNAME_BREAK : String = "Break";
		
		
		/**
		 * [static] The Clear Display key
		 */
		public static const KEYNAME_CLEARDISPLAY : String = "ClrDsp";
		
		
		/**
		 * [static] The Clear Line key
		 */
		public static const KEYNAME_CLEARLINE : String = "ClrLn";
		
		
		/**
		 * [static] The Delete key
		 */
		public static const KEYNAME_DELETE : String = "Delete";
		
		
		/**
		 * [static] The Delete Character key
		 */
		public static const KEYNAME_DELETECHAR : String = "DelChr";
		
		
		/**
		 * [static] The Delete Line key
		 */
		public static const KEYNAME_DELETELINE : String = "DelLn";
		
		
		/**
		 * [static] The down arrow
		 */
		public static const KEYNAME_DOWNARROW : String = "Down";
		
		
		/**
		 * [static] The End key
		 */
		public static const KEYNAME_END : String = "End";
		
		
		/**
		 * [static] The Execute key
		 */
		public static const KEYNAME_EXECUTE : String = "Exec";
		
		
		/**
		 * [static] The F1 key
		 */
		public static const KEYNAME_F1 : String = "F1";
		
		
		/**
		 * [static] The F10 key
		 */
		public static const KEYNAME_F10 : String = "F10";
		
		
		/**
		 * [static] The F11 key
		 */
		public static const KEYNAME_F11 : String = "F11";
		
		
		/**
		 * [static] The F12 key
		 */
		public static const KEYNAME_F12 : String = "F12";
		
		
		/**
		 * [static] The F13 key
		 */
		public static const KEYNAME_F13 : String = "F13";
		
		
		/**
		 * [static] The F14 key
		 */
		public static const KEYNAME_F14 : String = "F14";
		
		
		/**
		 * [static] The F15 key
		 */
		public static const KEYNAME_F15 : String = "F15";
		
		
		/**
		 * [static] The F16 key
		 */
		public static const KEYNAME_F16 : String = "F16";
		
		
		/**
		 * [static] The F17 key
		 */
		public static const KEYNAME_F17 : String = "F17";
		
		
		/**
		 * [static] The F18 key
		 */
		public static const KEYNAME_F18 : String = "F18";
		
		
		/**
		 * [static] The F19 key
		 */
		public static const KEYNAME_F19 : String = "F19";
		
		
		/**
		 * [static] The F2 key
		 */
		public static const KEYNAME_F2 : String = "F2";
		
		
		/**
		 * [static] The F20 key
		 */
		public static const KEYNAME_F20 : String = "F20";
		
		
		/**
		 * [static] The F21 key
		 */
		public static const KEYNAME_F21 : String = "F21";
		
		
		/**
		 * [static] The F22 key
		 */
		public static const KEYNAME_F22 : String = "F22";
		
		
		/**
		 * [static] The F23 key
		 */
		public static const KEYNAME_F23 : String = "F23";
		
		
		/**
		 * [static] The F24 key
		 */
		public static const KEYNAME_F24 : String = "F24";
		
		
		/**
		 * [static] The F25 key
		 */
		public static const KEYNAME_F25 : String = "F25";
		
		
		/**
		 * [static] The F26 key
		 */
		public static const KEYNAME_F26 : String = "F26";
		
		
		/**
		 * [static] The F27 key
		 */
		public static const KEYNAME_F27 : String = "F27";
		
		
		/**
		 * [static] The F28 key
		 */
		public static const KEYNAME_F28 : String = "F28";
		
		
		/**
		 * [static] The F29 key
		 */
		public static const KEYNAME_F29 : String = "F29";
		
		
		/**
		 * [static] The F3 key
		 */
		public static const KEYNAME_F3 : String = "F3";
		
		
		/**
		 * [static] The F30 key
		 */
		public static const KEYNAME_F30 : String = "F30";
		
		
		/**
		 * [static] The F31 key
		 */
		public static const KEYNAME_F31 : String = "F31";
		
		
		/**
		 * [static] The F32 key
		 */
		public static const KEYNAME_F32 : String = "F32";
		
		
		/**
		 * [static] The F33 key
		 */
		public static const KEYNAME_F33 : String = "F33";
		
		
		/**
		 * [static] The F34 key
		 */
		public static const KEYNAME_F34 : String = "F34";
		
		
		/**
		 * [static] The F35 key
		 */
		public static const KEYNAME_F35 : String = "F35";
		
		
		/**
		 * [static] The F4 key
		 */
		public static const KEYNAME_F4 : String = "F4";
		
		
		/**
		 * [static] The F5 key
		 */
		public static const KEYNAME_F5 : String = "F5";
		
		
		/**
		 * [static] The F6 key
		 */
		public static const KEYNAME_F6 : String = "F6";
		
		
		/**
		 * [static] The F7 key
		 */
		public static const KEYNAME_F7 : String = "F7";
		
		
		/**
		 * [static] The F8 key
		 */
		public static const KEYNAME_F8 : String = "F8";
		
		
		/**
		 * [static] The F9 key
		 */
		public static const KEYNAME_F9 : String = "F9";
		
		
		/**
		 * [static] The Find key
		 */
		public static const KEYNAME_FIND : String = "Find";
		
		
		/**
		 * [static] The Help key
		 */
		public static const KEYNAME_HELP : String = "Help";
		
		
		/**
		 * [static] The Home key
		 */
		public static const KEYNAME_HOME : String = "Home";
		
		
		/**
		 * [static] The Insert key
		 */
		public static const KEYNAME_INSERT : String = "Insert";
		
		
		/**
		 * [static] The Insert Character key
		 */
		public static const KEYNAME_INSERTCHAR : String = "InsChr";
		
		
		/**
		 * [static] The Insert Line key
		 */
		public static const KEYNAME_INSERTLINE : String = "InsLn";
		
		
		/**
		 * [static] The left arrow
		 */
		public static const KEYNAME_LEFTARROW : String = "Left";
		
		
		/**
		 * [static] The Menu key
		 */
		public static const KEYNAME_MENU : String = "Menu";
		
		
		/**
		 * [static] The Mode Switch key
		 */
		public static const KEYNAME_MODESWITCH : String = "ModeSw";
		
		
		/**
		 * [static] The Next key
		 */
		public static const KEYNAME_NEXT : String = "Next";
		
		
		/**
		 * [static] The Page Down key
		 */
		public static const KEYNAME_PAGEDOWN : String = "PgDn";
		
		
		/**
		 * [static] The Page Up key
		 */
		public static const KEYNAME_PAGEUP : String = "PgUp";
		
		
		/**
		 * [static] The Pause key
		 */
		public static const KEYNAME_PAUSE : String = "Pause";
		
		
		/**
		 * [static] The Play_Pause key
		 */
		public static const KEYNAME_PLAYPAUSE : String = "PlayPause";
		
		
		/**
		 * [static] The Previous key
		 */
		public static const KEYNAME_PREV : String = "Prev";
		
		
		/**
		 * [static] The Print key
		 */
		public static const KEYNAME_PRINT : String = "Print";
		
		
		/**
		 * [static] The Print Screen
		 */
		public static const KEYNAME_PRINTSCREEN : String = "PrntScrn";
		
		
		/**
		 * [static] The Redo key
		 */
		public static const KEYNAME_REDO : String = "Redo";
		
		
		/**
		 * [static] The Reset key
		 */
		public static const KEYNAME_RESET : String = "Reset";
		
		
		/**
		 * [static] The right arrow
		 */
		public static const KEYNAME_RIGHTARROW : String = "Right";
		
		
		/**
		 * [static] The Scroll Lock key
		 */
		public static const KEYNAME_SCROLLLOCK : String = "ScrlLck";
		
		
		/**
		 * [static] The Select key
		 */
		public static const KEYNAME_SELECT : String = "Select";
		
		
		/**
		 * [static] The Stop key
		 */
		public static const KEYNAME_STOP : String = "Stop";
		
		
		/**
		 * [static] The System Request key
		 */
		public static const KEYNAME_SYSREQ : String = "SysReq";
		
		
		/**
		 * [static] The System key
		 */
		public static const KEYNAME_SYSTEM : String = "Sys";
		
		
		/**
		 * [static] The Undo key
		 */
		public static const KEYNAME_UNDO : String = "Undo";
		
		
		/**
		 * [static] The up arrow
		 */
		public static const KEYNAME_UPARROW : String = "Up";
		
		
		/**
		 * [static] The User key
		 */
		public static const KEYNAME_USER : String = "User";
		
		
		/**
		 * [static] Constant associated with the key code value for the L key (76).
		 */
		public static const L : uint = 76;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for watching the last channel or show watched.
		 */
		public static const LAST : uint = 0x01000011;
		
		
		/**
		 * [static] Constant associated with the key code value for the Left Arrow key (37).
		 */
		public static const LEFT : uint = 37;
		
		
		/**
		 * [static] Constant associated with the key code value for the [ key (219).
		 */
		public static const LEFTBRACKET : uint = 219;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for returning to live [position in broadcast].
		 */
		public static const LIVE : uint = 0x01000010;
		
		
		/**
		 * [static] Constant associated with the key code value for the M key (77).
		 */
		public static const M : uint = 77;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging the "Master Shell" (e.g. TiVo or other vendor button).
		 */
		public static const MASTER_SHELL : uint = 0x0100001E;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging the menu.
		 */
		public static const MENU : uint = 0x01000012;
		
		
		/**
		 * [static] Constant associated with the key code value for the - key (189).
		 */
		public static const MINUS : uint = 189;
		
		
		/**
		 * [static] Constant associated with the key code value for the N key (78).
		 */
		public static const N : uint = 78;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for skipping to next track or chapter.
		 */
		public static const NEXT : uint = 0x0100000E;
		
		
		/**
		 * [static] Constant associated with the key code value for the 0 key (48).
		 */
		public static const NUMBER_0 : uint = 48;
		
		
		/**
		 * [static] Constant associated with the key code value for the 1 key (49).
		 */
		public static const NUMBER_1 : uint = 49;
		
		
		/**
		 * [static] Constant associated with the key code value for the 2 key (50).
		 */
		public static const NUMBER_2 : uint = 50;
		
		
		/**
		 * [static] Constant associated with the key code value for the 3 key (51).
		 */
		public static const NUMBER_3 : uint = 51;
		
		
		/**
		 * [static] Constant associated with the key code value for the 4 key (52).
		 */
		public static const NUMBER_4 : uint = 52;
		
		
		/**
		 * [static] Constant associated with the key code value for the 5 key (53).
		 */
		public static const NUMBER_5 : uint = 53;
		
		
		/**
		 * [static] Constant associated with the key code value for the 6 key (54).
		 */
		public static const NUMBER_6 : uint = 54;
		
		
		/**
		 * [static] Constant associated with the key code value for the 7 key (55).
		 */
		public static const NUMBER_7 : uint = 55;
		
		/**
		 * [static] Constant associated with the key code value for the 8 key (56).
		 */
		public static const NUMBER_8 : uint = 56;
		
		
		/**
		 * [static] Constant associated with the key code value for the 9 key (57).
		 */
		public static const NUMBER_9 : uint = 57;
		
		
		/**
		 * [static] Constant associated with the pseudo-key code for the the number pad (21).
		 */
		public static const NUMPAD : uint = 21;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 0 key on the number pad (96).
		 */
		public static const NUMPAD_0 : uint = 96;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 1 key on the number pad (97).
		 */
		public static const NUMPAD_1 : uint = 97;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 2 key on the number pad (98).
		 */
		public static const NUMPAD_2 : uint = 98;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 3 key on the number pad (99).
		 */
		public static const NUMPAD_3 : uint = 99;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 4 key on the number pad (100).
		 */
		public static const NUMPAD_4 : uint = 100;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 5 key on the number pad (101).
		 */
		public static const NUMPAD_5 : uint = 101;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 6 key on the number pad (102).
		 */
		public static const NUMPAD_6 : uint = 102;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 7 key on the number pad (103).
		 */
		public static const NUMPAD_7 : uint = 103;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 8 key on the number pad (104).
		 */
		public static const NUMPAD_8 : uint = 104;
		
		
		/**
		 * [static] Constant associated with the key code value for the number 9 key on the number pad (105).
		 */
		public static const NUMPAD_9 : uint = 105;
		
		
		/**
		 * [static] Constant associated with the key code value for the addition key on the number pad (107).
		 */
		public static const NUMPAD_ADD : uint = 107;
		
		
		/**
		 * [static] Constant associated with the key code value for the decimal key on the number pad (110).
		 */
		public static const NUMPAD_DECIMAL : uint = 110;
		
		
		/**
		 * [static] Constant associated with the key code value for the division key on the number pad (111).
		 */
		public static const NUMPAD_DIVIDE : uint = 111;
		
		
		/**
		 * [static] Constant associated with the key code value for the Enter key on the number pad (108).
		 */
		public static const NUMPAD_ENTER : uint = 108;
		
		
		/**
		 * [static] Constant associated with the key code value for the multiplication key on the number pad (106).
		 */
		public static const NUMPAD_MULTIPLY : uint = 106;
		
		
		/**
		 * [static] Constant associated with the key code value for the subtraction key on the number pad (109).
		 */
		public static const NUMPAD_SUBTRACT : uint = 109;
		
		
		/**
		 * [static] Constant associated with the key code value for the O key (79).
		 */
		public static const O : uint = 79;
		
		
		/**
		 * [static] Constant associated with the key code value for the P key (80).
		 */
		public static const P : uint = 80;
		
		
		/**
		 * [static] Constant associated with the key code value for the Page Down key (34).
		 */
		public static const PAGE_DOWN : uint = 34;
		
		
		/**
		 * [static] Constant associated with the key code value for the Page Up key (33).
		 */
		public static const PAGE_UP : uint = 33;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for pausing transport mode.
		 */
		public static const PAUSE : uint = 0x01000008;
		
		
		/**
		 * [static] Constant associated with the key code value for the .
		 */
		public static const PERIOD : uint = 190;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging play transport mode.
		 */
		public static const PLAY : uint = 0x01000007;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging play/pause transport mode.
		 */
		public static const PLAY_PAUSE : uint = 0x01000020;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for skipping to previous track or chapter.
		 */
		public static const PREVIOUS : uint = 0x0100000F;
		
		
		/**
		 * [static] Constant associated with the key code value for the Q key (81).
		 */
		public static const Q : uint = 81;
		
		
		/**
		 * [static] Constant associated with the key code value for the ' key (222).
		 */
		public static const QUOTE : uint = 222;
		
		
		/**
		 * [static] Constant associated with the key code value for the R key (82).
		 */
		public static const R : uint = 82;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for recording or engaging record transport mode.
		 */
		public static const RECORD : uint = 0x01000006;
		
		
		/**
		 * [static] Red function key button.
		 */
		public static const RED : uint = 0x01000000;
		
			
			/**
			 * [static] Constant associated with the key code value for the button for engaging rewind transport mode.
			 */
			public static const REWIND : uint = 0x0100000B;
		
		
		/**
		 * [static] Constant associated with the key code value for the Right Arrow key (39).
		 */
		public static const RIGHT : uint = 39;
		
		
		/**
		 * [static] Constant associated with the key code value for the ] key (221).
		 */
		public static const RIGHTBRACKET : uint = 221;
		
		
		/**
		 * [static] Constant associated with the key code value for the S key (83).
		 */
		public static const S : uint = 83;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for the search button.
		 */
		public static const SEARCH : uint = 0x0100001F;
		
		
		/**
		 * [static] Constant associated with the key code value for the ; key (186).
		 */
		public static const SEMICOLON : uint = 186;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging the setup application or menu.
		 */
		public static const SETUP : uint = 0x0100001C;
		
		
		/**
		 * [static] Constant associated with the key code value for the Shift key (16).
		 */
		public static const SHIFT : uint = 16;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging quick skip backward (usually 7-10 seconds).
		 */
		public static const SKIP_BACKWARD : uint = 0x0100000D;
		
			
			/**
			 * [static] Constant associated with the key code value for the button for engaging quick skip ahead (usually 30 seconds).
			 */
			public static const SKIP_FORWARD : uint = 0x0100000C;
		
			
			/**
			 * [static] Constant associated with the key code value for the / key (191).
			 */
			public static const SLASH : uint = 191;
		
		
		/**
		 * [static] Constant associated with the key code value for the Spacebar (32).
		 */
		public static const SPACE : uint = 32;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for stopping transport mode.
		 */
		public static const STOP : uint = 0x01000009;
		
		
		/**
		 * [static] The OS X Unicode Begin constant
		 */
		public static const STRING_BEGIN : String = "";
		
		
		/**
		 * [static] The OS X Unicode Break constant
		 */
		public static const STRING_BREAK : String = "";
		
		
		/**
		 * [static] The OS X Unicode Clear Display constant
		 */
		public static const STRING_CLEARDISPLAY : String = "";
		
		/**
		 * 
		 */
		
		/**
		 * [static] The OS X Unicode Clear Line constant
		 */
		public static const STRING_CLEARLINE : String = "";
		
		
		/**
		 * [static] The OS X Unicode Delete constant
		 */
		public static const STRING_DELETE : String = "";
		
		
		/**
		 * [static] The OS X Unicode Delete Character constant
		 */
		public static const STRING_DELETECHAR : String = "";
		
		
		/**
		 * [static] The OS X Unicode Delete Line constant
		 */
		public static const STRING_DELETELINE : String = "";
		
		
		/**
		 * [static] The OS X Unicode down arrow constant
		 */
		public static const STRING_DOWNARROW : String = "";
		
		
		/**
		 * [static] The OS X Unicode End constant
		 */
		public static const STRING_END : String = "";
		
		
		/**
		 * [static] The OS X Unicode Execute constant
		 */
		public static const STRING_EXECUTE : String = "";
		
		
		/**
		 * [static] The OS X Unicode F1 constant
		 */
		public static const STRING_F1 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F10 constant
		 */
		public static const STRING_F10 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F11 constant
		 */
		public static const STRING_F11 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F12 constant
		 */
		public static const STRING_F12 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F13 constant
		 */
		public static const STRING_F13 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F14 constant
		 */
		public static const STRING_F14 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F15 constant
		 */
		public static const STRING_F15 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F16 constant
		 */
		public static const STRING_F16 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F17 constant
		 */
		public static const STRING_F17 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F18 constant
		 */
		public static const STRING_F18 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F19 constant
		 */
		public static const STRING_F19 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F2 constant
		 */
		public static const STRING_F2 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F20 constant
		 */
		public static const STRING_F20 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F21 constant
		 */
		public static const STRING_F21 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F22 constant
		 */
		public static const STRING_F22 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F23 constant
		 */
		public static const STRING_F23 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F24 constant
		 */
		public static const STRING_F24 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F25 constant
		 */
		public static const STRING_F25 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F26 constant
		 */
		public static const STRING_F26 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F27 constant
		 */
		public static const STRING_F27 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F28 constant
		 */
		public static const STRING_F28 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F29 constant
		 */
		public static const STRING_F29 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F3 constant
		 */
		public static const STRING_F3 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F30 constant
		 */
		public static const STRING_F30 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F31 constant
		 */
		public static const STRING_F31 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F32 constant
		 */
		public static const STRING_F32 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F33 constant
		 */
		public static const STRING_F33 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F34 constant
		 */
		public static const STRING_F34 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F35 constant
		 */
		public static const STRING_F35 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F4 constant
		 */
		public static const STRING_F4 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F5 constant
		 */
		public static const STRING_F5 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F6 constant
		 */
		public static const STRING_F6 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F7 constant
		 */
		public static const STRING_F7 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F8 constant
		 */
		public static const STRING_F8 : String = "";
		
		
		/**
		 * [static] The OS X Unicode F9 constant
		 */
		public static const STRING_F9 : String = "";
		
		
		/**
		 * [static] The OS X Unicode Find constant
		 */
		public static const STRING_FIND : String = "";
		
		
		/**
		 * [static] The OS X Unicode Help constant
		 */
		public static const STRING_HELP : String = "";
		
		
		/**
		 * [static] The OS X Unicode Home constant
		 */
		public static const STRING_HOME : String = "";
		
		
		/**
		 * [static] The OS X Unicode Insert constant
		 */
		public static const STRING_INSERT : String = "";
		
		
		/**
		 * [static] The OS X Unicode Insert Character constant
		 */
		public static const STRING_INSERTCHAR : String = "";
		
		
		/**
		 * [static] The OS X Unicode Insert Line constant
		 */
		public static const STRING_INSERTLINE : String = "";
		
		
		/**
		 * [static] The OS X Unicode left arrow constant
		 */
		public static const STRING_LEFTARROW : String = "";
		
		
		/**
		 * [static] The OS X Unicode Menu constant
		 */
		public static const STRING_MENU : String = "";
		
		
		/**
		 * [static] The OS X Unicode Mode Switch constant
		 */
		public static const STRING_MODESWITCH : String = "";
		
		
		/**
		 * [static] The OS X Unicode Next constant
		 */
		public static const STRING_NEXT : String = "";
		
		
		/**
		 * [static] The OS X Unicode Page Down constant
		 */
		public static const STRING_PAGEDOWN : String = "";
		
		
		/**
		 * [static] The OS X Unicode Page Up constant
		 */
		public static const STRING_PAGEUP : String = "";
		
		
		/**
		 * [static] The OS X Unicode Pause constant
		 */
		public static const STRING_PAUSE : String = "";
		
		
		/**
		 * [static] The OS X Unicode Previous constant
		 */
		public static const STRING_PREV : String = "";
		
		
		/**
		 * [static] The OS X Unicode Print constant
		 */
		public static const STRING_PRINT : String = "";
		
		
		/**
		 * [static] The OS X Unicode Print Screen constant
		 */
		public static const STRING_PRINTSCREEN : String = "";
		
		
		/**
		 * [static] The OS X Unicode Redo constant
		 */
		public static const STRING_REDO : String = "";
		
		
		/**
		 * [static] The OS X Unicode Reset constant
		 */
		public static const STRING_RESET : String = "";
		
		
		/**
		 * [static] The OS X Unicode right arrow constant
		 */
		public static const STRING_RIGHTARROW : String = "";
		
		
		/**
		 * [static] The OS X Unicode Scroll Lock constant
		 */
		public static const STRING_SCROLLLOCK : String = "";
		
		
		/**
		 * [static] The OS X Unicode Select constant
		 */
		public static const STRING_SELECT : String = "";
		
		
		/**
		 * [static] The OS X Unicode Stop constant
		 */
		public static const STRING_STOP : String = "";
		
		
		/**
		 * [static] The OS X Unicode System Request constant
		 */
		public static const STRING_SYSREQ : String = "";
		
		
		/**
		 * [static] The OS X Unicode System constant
		 */
		public static const STRING_SYSTEM : String = "";
		
		
		/**
		 * [static] The OS X Unicode Undo constant
		 */
		public static const STRING_UNDO : String = "";
		
		
		/**
		 * [static] The OS X Unicode up arrow constant
		 */
		public static const STRING_UPARROW : String = "";
		
		
		/**
		 * [static] The OS X Unicode User constant
		 */
		public static const STRING_USER : String = "";
		
		
		/**
		 * [static] Constant associated with the key code value for the button for toggling subtitles.
		 */
		public static const SUBTITLE : uint = 0x01000018;
		
		
		/**
		 * [static] Constant associated with the key code value for the T key (84).
		 */
		public static const T : uint = 84;
		
		
		/**
		 * [static] Constant associated with the key code value for the Tab key (9).
		 */
		public static const TAB : uint = 9;
		
		
		/**
		 * [static] Constant associated with the key code value for the U key (85).
		 */
		public static const U : uint = 85;
		
		
		/**
		 * [static] Constant associated with the key code value for the Up Arrow key (38).
		 */
		public static const UP : uint = 38;
		
		
		/**
		 * [static] Constant associated with the key code value for the V key (86).
		 */
		public static const V : uint = 86;
		
		
		/**
		 * [static] Constant associated with the key code value for the button for engaging video-on-demand.
		 */
		public static const VOD : uint = 0x0100001A;
		
		
		/**
		 * [static] Constant associated with the key code value for the W key (87).
		 */
		public static const W : uint = 87;
		
		
		/**
		 * [static] Constant associated with the key code value for the X key (88).
		 */
		public static const X : uint = 88;
		
		
		/**
		 * [static] Constant associated with the key code value for the Y key (89).
		 */
		public static const Y : uint = 89;
		
		
		/**
		 * [static] Constant associated with the key code value for the yellow function key button.
		 */
		public static const YELLOW : uint = 0x01000002;
		
		
		/**
		 * [static] Constant associated with the key code value for the Z key (90).
		 */
		public static const Z : uint = 90;
		
		
	}
}
