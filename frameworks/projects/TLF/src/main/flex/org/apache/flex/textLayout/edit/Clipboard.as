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
package org.apache.royale.textLayout.edit
{
    COMPILE::SWF
    {
        import flash.desktop.Clipboard;
        import org.apache.royale.utils.UIDUtil;
    }
    COMPILE::JS
    {
        import org.apache.royale.textLayout.events.EditEvent;
        import org.apache.royale.events.Event;
    }
	/** 
	 * The Clipboard class is used for Clipboard operations such as copy and paste
	 * It wraps the Flash Clipboard class and creates a new one on the Javascript side.
     * To use the Javascript version, it is necessary to assign a static `clipElement` which needs
     * to be a `contenteditable` HTML Element. This is to work around Browser issues related to Copy and Paste.
	 * 
	 */
    COMPILE::SWF
    public class Clipboard
    {
        public function get clipElement():Object
        {
            return null;
        }
        public function set clipElement(value:Object):void
        {
            // nothing for Flash
        }
        private static function get systemClipboard():flash.desktop.Clipboard
        {
            return flash.desktop.Clipboard.generalClipboard;
        }
        private static var _generalClipboard:org.apache.royale.textLayout.edit.Clipboard;
        public static function get generalClipboard():org.apache.royale.textLayout.edit.Clipboard
        {
            if(_generalClipboard == null)
                _generalClipboard = new org.apache.royale.textLayout.edit.Clipboard();
            return _generalClipboard;
        }
		public function hasFormat(format:String):Boolean
        {
			return systemClipboard.hasFormat(format);
		}

		public function getData(clipboardFormat:String):Object
        {
            return systemClipboard.getData(clipboardFormat);
		}

		public function clear():void
        {
            systemClipboard.clear();
		}

        public function clearData(format:String):void
        {
            systemClipboard.clearData(format);
        }

		public function setData(clipboardFormat:String, clipboardData:String):void
        {
            systemClipboard.setData(clipboardFormat, clipboardData);
		}

        public function setDataHandler(format:String, handler:Function, serializable:Boolean = true):Boolean
        {
            return systemClipboard.setDataHandler(format, handler, serializable);
        }
        // Do nothing in Flash
        public function registerCallback(callback:Function):void{}

    }

    COMPILE::JS
    public class Clipboard
    {

        private var _clipElement:Object;
        public function get clipElement():Object
        {
            return _clipElement;
        }
        public function set clipElement(value:Object):void
        {
            if(!_clipElement)
            {
                document["addEventListener"]('cut',onCut);
                document["addEventListener"]('copy',onCopy);
                document["addEventListener"]('paste',onPaste);
                
            }
            _clipElement = value;
        }
        private var currentEvent:Object;
        private function onCopy(e:Event):void
        {
            currentEvent = e;
            if(_callback)
                _callback(new Event(EditEvent.COPY));
            // only call the callback once
            _callback = null;
        }
        private function onCut(e:Event):void
        {
            currentEvent = e;
            if(_callback)
                _callback(new Event(EditEvent.CUT));
            // only call the callback once
            _callback = null;
            
        }
        private function onPaste(e:Event):void
        {
            currentEvent = e;

            // check if the paste is outside content or TLF content
            var pasteboardText:String;
                if(window["clipboardData"]) {//IE
                    pasteboardText = window["clipboardData"].getData("Text");
                } else if(currentEvent["clipboardData"]) {
                    pasteboardText = currentEvent["clipboardData"].getData("text/plain");
                }
            if(pasteboardText != getData("text/plain"))
            {
                clear();
                setData("text/plain",pasteboardText);
            }
            if(_callback)
                _callback(new Event(EditEvent.PASTE));
            // only call the callback once
            _callback = null;
            
        }

        private static var _generalClipboard:Clipboard;
		public static function get generalClipboard():Clipboard{
            if(_generalClipboard == null)
                _generalClipboard = new Clipboard();
            
            return _generalClipboard;
        }
        private var _formats:Object = {};
		public function hasFormat(format:String):Boolean {
            return _formats[format] != null;
		}

		public function getData(clipboardFormat:String):Object
        {
            return _formats[clipboardFormat];
		}

		public function clear() : void {
            _formats = {};
		}
		public function setData(clipboardFormat:String, clipboardData:Object) : void {
            _formats[clipboardFormat] = clipboardData;
            if(clipboardFormat == "text/plain")
            {
                if(window["clipboardData"]) {//IE
                    window["clipboardData"].setData("Text", clipboardData);        
                } else if(currentEvent["clipboardData"]) {
                    currentEvent["clipboardData"].setData("text/plain", clipboardData);      
                }
            }
		}
        public function preventDefault():void
        {
            if(currentEvent)
                currentEvent.preventDefault();
        }
        private var _callback:Function;
        // We need to register a callback to know what to do with the copy, cut and paste events
        public function registerCallback(callback:Function):void
        {
            _callback = callback;
        }

    }    

}
