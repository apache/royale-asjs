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
package org.apache.royale.jewel.supportClasses.radiobutton
{
	COMPILE::JS {
        import org.apache.royale.core.WrappedHTMLElement;
    }

	/**
	 *  The RadioButton class is a component that displays a selectable Button. RadioButtons
	 *  are typically used in groups, identified by the groupName property. RadioButton use
	 *  the following beads:
	 *
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the groupName.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the RadioButton..
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class RadioButtonIcon
	{
		public function RadioButtonIcon()
		{
			COMPILE::JS {
				createElement();
			}

			className = 'RadioButtonIcon';
		}

        /**
         * @private
         * 
         * @royalesuppresspublicvarwarning
         */
		COMPILE::JS 
		public var element:WrappedHTMLElement;
		
		COMPILE::JS
		public function get positioner():WrappedHTMLElement
		{
			return element;
		}
		
		private var _className:String;

		/**
		 * @private
		 */
		public function get className():String
		{
			return _className;
		}
		public function set className(value:String):void
		{
			_className = value;

			COMPILE::JS {
				element.className = value;
			}
		}

		private var _id:String;

		/**
		 * @private
		 */
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			_id = value;

			COMPILE::JS {
				element.id = value;
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLInputElement
		 * @royaleignorecoercion Text
		 */
		COMPILE::JS
 		protected function createElement():WrappedHTMLElement
		{
			//This class does not subclass anything, so these properties must be set explicitly
			var input:HTMLInputElement = document.createElement('input') as HTMLInputElement;
			input.type = 'radio';

			element = input as WrappedHTMLElement;
			element.royale_wrapper = this;

			return element;
		}
	}
}
