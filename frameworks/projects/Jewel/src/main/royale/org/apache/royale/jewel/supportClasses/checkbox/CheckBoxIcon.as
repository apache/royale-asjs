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
package org.apache.royale.jewel.supportClasses.checkbox
{
	COMPILE::JS {
        import org.apache.royale.core.WrappedHTMLElement;
    }

	public class CheckBoxIcon
	{
		public function CheckBoxIcon()
		{
			COMPILE::JS {
				createElement();
			}

			className = 'CheckBoxIcon';
		}

		COMPILE::JS {
			/**
			 * @royalesuppresspublicvarwarning
			 */
            public var element:WrappedHTMLElement;
			/**
			 * @royalesuppresspublicvarwarning
			 */
            public var positioner:WrappedHTMLElement;
		}

		private var _className:String;

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
			var input:HTMLInputElement = document.createElement('input') as HTMLInputElement;
			input.type = 'checkbox';

			element = input as WrappedHTMLElement;
			return element;
		}
	}
}
