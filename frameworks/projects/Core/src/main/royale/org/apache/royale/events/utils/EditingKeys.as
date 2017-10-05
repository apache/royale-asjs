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
	 *  This class holds constants for editing keys
     *  See: https://w3c.github.io/uievents-key/#keys-editing
     *  See: https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key/Key_Values#Editing_keys
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
    public class EditingKeys
    {
        
        /**
         * The Backspace key. This key is labeled Delete on Mac keyboards.
         */
        public static const BACKSPACE:String = "Backspace";
        
        /**
         * The Clear key. Removes the currently selected input.
         */
        public static const CLEAR:String = "Clear";
        
        /**
         * The Copy key (on certain extended keyboards).
         */
        public static const COPY:String = "Copy";
        
        /**
         * The Cursor Select key, CrSel.
         */
        public static const CURSOR_SELECT:String = "CrSel";
        
        /**
         * The Cut key (on certain extended keyboards).
         */
        public static const CUT:String = "Cut";
        
        /**
         * The Delete key, Del.
         */
        public static const DELETE:String = "Delete";
        
        /**
         * Erase to End of Field. Deletes all characters from the current cursor position to the end of the current field.
         */
        public static const ERASE_EOF:String = "EraseEof";
        
        /**
         * The ExSel (Extend Selection) key.
         */
        public static const EXTEND_SELECTION:String = "ExSel";
        
        /**
         * The Insert key, Ins. Toggles  between inserting and overwriting text.
         */
        public static const INSERT:String = "Insert";
        
        /**
         * Paste from the clipboard.
         */
        public static const PASTE:String = "Paste";
        
        /**
         * Redo the last action.
         */
        public static const REDO:String = "Redo";
        
        /**
         * Undo the last action.
         */
        public static const UNDO:String = "Undo";

    }
}
