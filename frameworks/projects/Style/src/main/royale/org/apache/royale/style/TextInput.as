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
package org.apache.royale.style
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IMXMLDocument;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.MXMLDataInterpreter;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.elements.Label;
	import org.apache.royale.style.elements.Input;
	import org.apache.royale.style.skins.TextInputSkin;
	

	public class TextInput extends Input
	{
		public function TextInput()
		{
			super();
			type = "text";
		}
		private var _placeholder:String;
		public function set placeholder(value:String):void
		{
			_placeholder = value;
			COMPILE::JS
			{
				(element as HTMLInputElement).placeholder = value;
			}
		}
		public function get placeholder():String
		{
			return _placeholder;
		}
		private var _pattern:String;
		public function set pattern(value:String):void
		{
			_pattern = value;
			COMPILE::JS
			{
				(element as HTMLInputElement).pattern = value;
			}
		}
		public function get pattern():String
		{
			return _pattern;
		}
		private var _minlength:Number;
		public function set minlength(value:Number):void
		{
			_minlength = value;
			COMPILE::JS
			{
				element["minlength"] = value;
			}
		}
		public function get minlength():Number
		{
			return _minlength;
		}
		private var _maxlength:Number;
		public function set maxlength(value:Number):void
		{
			_maxlength = value;
			COMPILE::JS
			{
				element["maxlength"] = value;
			}
		}
		public function get maxlength():Number
		{
			return _maxlength;
		}
		private var _min:String;
		public function set min(value:String):void
		{
			_min = value;
			COMPILE::JS
			{
				(element as HTMLInputElement).min = value;
			}
		}
		public function get min():String
		{
			return _min;
		}
		private var _max:String;
		public function set max(value:String):void
		{
			_max = value;
			COMPILE::JS
			{
				(element as HTMLInputElement).max = value;
			}
		}
		public function get max():String
		{
			return _max;
		}
	}
}