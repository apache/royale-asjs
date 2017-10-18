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
package org.apache.royale.events.utils
{
	/**
	 *  This class holds constants for modifier keys
     *  See: https://w3c.github.io/uievents-key/#keys-modifier
     *  See: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values#Modifier_keys
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
    public class ModifierKeys
    {

        /**
        * The Alt (Alternative) key.
        */
        public static const ALT:String = "Alt";

        /**
        * The AltGr or AltGraph (Alternate Graphics) key. Enables the ISO Level 3 shift modifier (where Shift is the level 2 modifier).
        */
        public static const ALT_GRAPH:String = "AltGraph";
        
        /**
         * The Caps Lock key. Toggles the capital character lock on and off for subsequent input.
         */
        public static const CAPS_LOCK:String = "CapsLock";
        
        /**
         * The Control, Ctrl, or Ctl key. Alows typing control characters.
         */
        public static const CONTROL:String = "Control";
        
        /**
         * The Fn (Function modifier) key. Used to allow generating function key (F1-F15, for instance)
         * characters on keyboards without a dedicated function key area. Often handled in hardware so that events aren't generated for this key.
         */
        public static const FN:String = "Fn";
        
        /**
         * The Meta key. Allows issuing special command inputs. This is the Windows logo key, or the Command or ⌘ key on Mac keyboards.
         */
        public static const META:String = "Meta";

        /**
         * The NumLock (Number Lock) key. Toggles the numeric keypad between number entry some other mode (often directional arrows).
         */
        public static const NUM_LOCK:String = "NumLock";
        
        /**
         * The Scroll Lock key. Toggles beteen scrolling and cursor movement modes.
         */
        public static const SCROLL_LOCK:String = "ScrollLock";

        /**
         * The Shift key. Modifies keystrokes to allow typing upper (or other) case letters,
         * and to support typing punctuation and other special characters.
         */
        public static const SHIFT:String = "Shift";
        
        /**
         * The Super key.
         */
        public static const SUPER:String = "Super";
        
        /**
         * The Symbol modifier key (found on certain virtual keyboards).
         */
        public static const SYMBOL:String = "Symbol";
        
        /**
         * The Symbol Lock key.
         */
        public static const SYMBOL_LOCK:String = "SymbolLock";

    }
}
