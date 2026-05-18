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
package org.apache.royale.style.elements
{
	import org.apache.royale.style.support.NodeElementBase;

	/**
	 *  The Textarea class represents an HTML <textarea> element
	 *
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @productversion Royale 1.0.0
	 */
	public class Textarea extends NodeElementBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function Textarea()
		{
			super();
		}

		/**
		 * @royaleignorecoercion HTMLTextAreaElement
		 */
		COMPILE::JS
		private function get textarea():HTMLTextAreaElement
		{
			return element as HTMLTextAreaElement;
		}

		COMPILE::SWF
		private var _cols:uint = 20;

		/**
		 *  Width of textarea in (average) character widths
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get cols():uint
		{
			COMPILE::SWF
			{
				return _cols;
			}

			COMPILE::JS
			{
				return textarea.cols;
			}
		}
		public function set cols(value:uint):void
		{
			COMPILE::SWF
			{
				_cols = value;
			}
			COMPILE::JS
			{
				textarea.cols = value;
			}
		}

		COMPILE::SWF
		private var _rows:uint;

		/**
		 *  Number of visible lines
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get rows():uint
		{
			COMPILE::SWF
			{
				return _rows;
			}

			COMPILE::JS
			{
				return textarea.rows;
			}
		}
		public function set rows(value:uint):void
		{
			COMPILE::SWF
			{
				_rows = value;
			}
			COMPILE::JS
			{
				textarea.rows = value;
			}
		}

		COMPILE::SWF

		private var _disabled:Boolean;

		/**
		 *  Whether the textarea is disabled
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get disabled():Boolean
		{
			COMPILE::SWF
			{
				return _disabled;
			}

			COMPILE::JS
			{
				return textarea.disabled;
			}
		}
		public function set disabled(value:Boolean):void
		{
			COMPILE::SWF
			{
				_disabled = value;
			}
			COMPILE::JS
			{
				textarea.disabled = value;
			}
		}

		/**
		 *  The textarea name
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		COMPILE::JS

		public function get name():String
		{
			return textarea.name;
		}
		COMPILE::JS

		public function set name(value:String):void
		{
			textarea.name = value;
		}

		COMPILE::SWF

		override public function get name():String
		{
			return super.name;
		}
		COMPILE::SWF

		override public function set name(value:String):void
		{
			super.name = value;
		}

		COMPILE::SWF

		private var _value:String = "";

		/**
		 *  The current value of the textarea
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
		 */
		public function get value():String
		{
			COMPILE::SWF
			{
				return _value;
			}
			COMPILE::JS
			{
				return textarea.value;
			}
		}

		public function set value(value:String):void
		{
			COMPILE::SWF
			{
				_value = value;
			}
			COMPILE::JS
			{
				textarea.value = value;
			}
		}
		
		public function get readonly():Boolean
		{
			COMPILE::JS
			{
				return textarea.readOnly;
			}
			COMPILE::SWF
			{
				return false
			}
		}
		
		public function set readonly(value:Boolean):void
		{
			COMPILE::JS
			{
				textarea.readOnly = value;
			}
		}
		
		public function get placeholder():String
		{
			COMPILE::JS
			{
				return textarea.placeholder;
			}
			COMPILE::SWF
			{
				return null
			}
		}
		
		public function set placeholder(value:String):void
		{
			COMPILE::JS
			{
				//set the content in the textArea
				textarea.placeholder = value;
			}
		}
		
		private var _required:Boolean;
		
		public function get required():Boolean
		{
			return _required;
		}
		
		public function set required(value:Boolean):void
		{
			if(value != !!_required){
				toggleAttribute('required',value);
			}
			_required = value;
		}
		
		private var _invalid:Boolean;
		/**
		 * Indicates whether the current state of the component is invalid.
		 * This can be used to apply error styles to the component.
		 *
		 * The Checkbox skin should specify invalid styles if desired.
		 *
		 * @languageversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get invalid():Boolean
		{
			return _invalid;
		}
		
		public function set invalid(value:Boolean):void
		{
			COMPILE::JS
			{
				if(value != !!_invalid){
					toggleAttribute("data-invalid", value);
				}
			}
			_invalid = value;
		}

		override protected function getTag():String
		{
			return "textarea";
		}
		 public function get minlength():String
        {
            COMPILE::JS
            {
                return element["minLength"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set minlength(value:String):void
        {
            COMPILE::JS
            {
                element["minLength"] = parseInt(value);
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get maxlength():String
        {
            COMPILE::JS
            {
                return element["maxLength"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set maxlength(value:String):void
        {
            COMPILE::JS
            {
                element["maxLength"] = parseInt(value);
            }
            COMPILE::SWF
            {
                return;

            }
        }

        COMPILE::JS

        public function get spellcheck():String
        {
            COMPILE::JS
            {
                return element["spellcheck"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set spellcheck(value:String):void
        {
            COMPILE::JS
            {
                element["spellcheck"] = (value == "true");
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get wrap():String
        {
            COMPILE::JS
            {
                return element["wrap"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set wrap(value:String):void
        {
            COMPILE::JS
            {
                element["wrap"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get form():String
        {
            COMPILE::JS
            {
                return element["form"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set form(value:String):void
        {
            COMPILE::JS
            {
                element["form"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get dirname():String
        {
            COMPILE::JS
            {
                return element["dirName"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set dirname(value:String):void
        {
            COMPILE::JS
            {
                element["dirName"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get autocorrect():String
        {
            COMPILE::JS
            {
                return element["autocorrect"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set autocorrect(value:String):void
        {
            COMPILE::JS
            {
                element["autocorrect"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get autocomplete():String
        {
            COMPILE::JS
            {
                return element["autocomplete"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set autocomplete(value:String):void
        {
            COMPILE::JS
            {
                element["autocomplete"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

        public function get autocapitalize():String
        {
            COMPILE::JS
            {
                return element["autocapitalize"].toString();
            }
            COMPILE::SWF
            {
                return "";
            }
        }
        public function set autocapitalize(value:String):void
        {
            COMPILE::JS
            {
                element["autocapitalize"] = value;
            }
            COMPILE::SWF
            {
                return;
            }
        }

	}
}
