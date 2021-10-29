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

package mx.system
{
	COMPILE::SWF
	{
		import flash.system.System;
	}

	/**
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.0
	 *  @productversion Royale 0.9.8
	 */

	public class System
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.0
		 *  @productversion Royale 0.9.8
		 */

		public function System()
		{
		}
		
		/**
		 *  Replaces the contents of the Clipboard with a specified text string.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.0
		 *  @productversion Royale 0.9.8
		 */

		public static function setClipboard(str:String):void
		{
			COMPILE::SWF
			{
				flash.system.System.setClipboard(str);
			}
			
			COMPILE::JS
			{
				var pre:HTMLPreElement = document.createElement("pre") as HTMLPreElement;
				pre.innerText = str;
				pre.id = "copyToClipboard";
				document.body.appendChild( pre );
				var copyToClipboard:Element = document.getElementById("copyToClipboard");
				var selection:Selection = window.getSelection();
				var range:Range = document.createRange();
				range.selectNodeContents(copyToClipboard);
				selection.removeAllRanges();
				selection.addRange(range);
				document.execCommand("copy");
				document.body.removeChild( pre );
			}
		}
		
		public static function get totalMemory():uint {
			return 0;
		}
		
		
		public static var _useCodePage:Boolean = false;
		public static function get useCodePage():Boolean {
			return _useCodePage;
		}
		public static function set useCodePage(value:Boolean):void {
			_useCodePage = value;
		}
	}
}
