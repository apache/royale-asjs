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
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.elements.Span;
    import org.apache.royale.mdl.TextField;
    import org.apache.royale.mdl.supportClasses.ITextField;
    import org.apache.royale.utils.StringTrimmer;

    /**
	 *  The NonEmptyTextField bead should be used only with MDL TextField
	 *  It checks whether TextField contains non empty string.
	 *  If it is empty bead display message assigned to "error" property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class NonEmptyTextField implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function NonEmptyTextField()
		{
		}

		private var _spanError:Span;
        private var _error:String = "";

        /**
		 *  The string to use as error text in the associated span.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
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
		private var _host:TextField;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			_host = value as TextField;

			IEventDispatcher(value).addEventListener("change", onTextFieldChange);
			COMPILE::JS
			{
				_spanError = new Span();
				_spanError.element.classList.add("mdl-textfield__error");

				_host.positioner.appendChild(_spanError.element);

				updateError();
			}
		}

        private function onTextFieldChange(event:Event):void
        {
			COMPILE::JS
            {
                if (!StringTrimmer.trim(_host.text))
                {
                    _host.element.setAttribute("required", "required");
					_host.isInvalid = true;
                }
                else
                {
                    _host.element.removeAttribute("required");
                }
            }
        }
	}
}
