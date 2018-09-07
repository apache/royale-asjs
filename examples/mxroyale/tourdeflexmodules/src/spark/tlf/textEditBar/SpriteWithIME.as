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
package textEditBar
{
	import flash.display.Sprite;
	
	import mx.core.IIMESupport;
	import mx.managers.IFocusManagerComponent;

	public class SpriteWithIME extends Sprite implements IIMESupport, IFocusManagerComponent
	{
		private var _imeMode:String;
		
		public function SpriteWithIME()
		{
			super();
		}
		
		public function get enableIME():Boolean
		{
			return true;
		}
		
		public function get imeMode():String
		{
			return _imeMode;
		}
		
		public function set imeMode(value:String):void
		{
			_imeMode = value;
		}
		
		public function get focusEnabled():Boolean
		{
			return true;
		}
		
		public function set focusEnabled(value:Boolean):void
		{
		}
		
		// For now! Should be dependent on Configuration.manageTabKey
		public function get tabFocusEnabled():Boolean
		{
			return true;
		}
		
		public function set tabFocusEnabled(value:Boolean):void
		{
		}
		
		public function get hasFocusableChildren():Boolean
		{
			return false;
		}
		
		public function set hasFocusableChildren(value:Boolean):void
		{
		}
		
		public function get mouseFocusEnabled():Boolean
		{
			return false;
		}
		
		/*public function get tabEnabled():Boolean
		{
			return false;
		}
		
		public function get tabIndex():int
		{
			return 0;
		}*/
		
		public function setFocus():void
		{
		}
		
		public function drawFocus(isFocused:Boolean):void
		{
		}
		
	}
}