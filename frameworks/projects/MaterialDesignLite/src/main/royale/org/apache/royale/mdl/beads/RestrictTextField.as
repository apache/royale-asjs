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
package org.apache.royale.mdl.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.elements.Span;
    import org.apache.royale.mdl.supportClasses.ITextField;
	
	/**
	 *  The RestrictTextField bead class is a specialty bead that can be used with
	 *  any MDL TextField control. The bead uses a reg exp pattern to validate
	 *  input from user. A text property allows to configure error text.
	 *  
	 *  use examples:
	 *  Numeric pattern = -?[0-9]*(&#92;.[0-9]+)?
	 *  error text = "Input is not a number!"
	 *
	 *  Letters and spaces only pattern = [A-Z,a-z, ]*
	 *  error text = "Letters and spaces only";
	 *
	 *  Digits only = [0-9]*
	 *  error text = "Digits only";
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class RestrictTextField implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function RestrictTextField()
		{
		}
		
		private var _pattern:String = "";
		
		/**
		 *  The string to use as numeric pattern.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get pattern():String
		{
			return _pattern;
		}
		public function set pattern(value:String):void
		{
			_pattern = value;
			updatePattern();
		}

		private function updatePattern():void
		{
			COMPILE::JS
			{
                var mdlTi:ITextField = _strand as ITextField;
				if (mdlTi)
                {
                    mdlTi.input.setAttribute('pattern', pattern);
                }
			}
		}

		private var _spanError:Span;
        private var _error:String = "";

        /**
		 *  The string to use as error text in the associated span.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get error():String
        {
            return _error;
        }
        public function set error(value:String):void
        {
            _error = value;
			updateError();
        }

        private function updateError():void
        {
            COMPILE::JS
            {
                if (_spanError)
				{
					_spanError.text = error;
				}
            }
        }

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			COMPILE::JS
			{
				_spanError = new Span();
				_spanError.element.classList.add("mdl-textfield__error");

				UIBase(value).positioner.appendChild(_spanError.element);

				updateError();
				updatePattern();
			}
		}
	}
}
