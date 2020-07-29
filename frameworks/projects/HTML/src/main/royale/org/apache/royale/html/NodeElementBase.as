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
package org.apache.royale.html
{
	import org.apache.royale.html.Group;

	public class NodeElementBase extends Group
	{
		public function NodeElementBase()
		{
			super();
			typeNames = "";
		}

		COMPILE::SWF
		{
			private var _nodeValue:String;
		}
		public function get nodeValue():String
		{
			COMPILE::SWF
			{
				return _nodeValue;
			}

			COMPILE::JS
			{
				return element.nodeValue;
			}
		}

		public function set nodeValue(value:String):void
		{
			COMPILE::SWF
			{
				_nodeValue = value;
			}

			COMPILE::JS
			{
				element.nodeValue = value;
			}
		
		}

		public function get class():String
		{
			COMPILE::SWF
			{
				return "";
			}

			COMPILE::JS
			{
				return element.getAttribute("class");
			}
		}

		public function set class(value:String):void
		{
			COMPILE::JS
			{
				element.setAttribute("class",value);
			}
		}

		public function get contentEditable():String
		{
			COMPILE::SWF
			{
				return "false";
			}
			COMPILE::JS
			{
				return element.contentEditable;
			}
		}

		[Inspectable(category="General", enumeration="true,false,inherit", defaultValue="inherit")]
		public function set contentEditable(value:String):void
		{
			COMPILE::JS
			{
				element.contentEditable = value;
			}
		}

		public function get isContentEditable():Boolean
		{
			COMPILE::SWF
			{
				return false;
			}
			COMPILE::JS
			{
				return element.isContentEditable;
			}
		}

		public function set isContentEditable(value:Boolean):void
		{
			COMPILE::JS
			{
				element.isContentEditable = value;
			}
		}
		/**
		 * The direction of the element.
		 */
		public function get dir():String
		{
			COMPILE::SWF
			{
				return "";
			}

			COMPILE::JS
			{
				return element.dir;
			}
		}

		[Inspectable(category="General", enumeration="ltr,rtl,auto", defaultValue="auto")]
		public function set dir(value:String):void
		{
			COMPILE::JS
			{
				element.dir = value;
			}
		}

		COMPILE::SWF
		private var _hidden:Boolean;

		/**
		 * Indicates whether the element is hidden or not.
		 */
		public function get hidden():Boolean
		{
			COMPILE::SWF
			{
				return _hidden;
			}
			COMPILE::JS
			{
				return element.hidden;
			}
		}

		public function set hidden(value:Boolean):void
		{
			COMPILE::SWF
			{
				_hidden = value;
			}
			COMPILE::JS
			{
				element.hidden = value;
			}
		}
		/**
		 * Represents the "rendered" text content of a node and its descendants.
		 * As a getter, it approximates the text the user would get if they highlighted the contents
		 * of the element with the cursor and then copied it to the clipboard.
		 */
		COMPILE::SWF
		private var _innerText:String;

		public function get innerText():String
		{
			COMPILE::SWF{
				return _innerText;
			}
			COMPILE::JS
			{
				return element.innerText;
			}
		}

		public function set innerText(value:String):void
		{
			COMPILE::SWF
			{
				_innerText = value;				
			}
			COMPILE::JS
			{
				element.innerText = value;
			}
		}
		COMPILE::SWF
		private var _lang:String;
		/**
		 * https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/lang
		 */
		public function get lang():String
		{
			COMPILE::SWF
			{
				return _lang;
			}
			
			COMPILE::JS
			{
				return element.lang;
			}
		}

		public function set lang(value:String):void
		{
			COMPILE::SWF
			{
				_lang = value;
			}

			COMPILE::JS
			{
				element.lang = value;
			}
		}
		COMPILE::SWF
		private var _title:String;

		public function get title():String
		{
			COMPILE::SWF
			{
				return _title;
			}

			COMPILE::JS
			{
				return element.title;
			}
		}

		public function set title(value:String):void
		{
			COMPILE::SWF
			{
				_title = value;
			}

			COMPILE::JS
			{
				element.title = value;
			}
		}

		COMPILE::SWF
		override public function get tabIndex():int{
			return super.tabIndex;
		}
		COMPILE::SWF
		override public function set tabIndex(value:int):void{
			super.tabIndex = value;
		}

		COMPILE::JS
		public function get tabIndex():int
		{
			return element.tabIndex;
		}
		COMPILE::JS
		public function set tabIndex(value:int):void
		{
			element.tabIndex = value;
		}
		
		COMPILE::SWF
		protected var _attributes_:Object = {};
		public function setAttribute(name:String,value:String):void
		{
			COMPILE::JS
			{
				element.setAttribute(name,value);
			}
			COMPILE::SWF
			{
				_attributes_[name] = value;
			}
				
		}
		public function getAttribute(name:String):String
		{
			COMPILE::JS
			{
				return element.getAttribute(name);
			}
			COMPILE::SWF
			{
				return _attributes_[name];
			}
		}
	}
}