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
package org.apache.royale.html5
{
	COMPILE::JS {
		import org.apache.royale.core.UIBase;
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
	}

	import org.apache.royale.html.DateField;
	import org.apache.royale.events.Event;

	/**
	 * A valueChange event is dispatched whenever the selected date changes. It corresponds
	 * to the change event dispatched by the basic:DateField component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	/**
	 * The HTML5:DateField displays a date input selector when run on an HTML5-compatible browser.
	 * On non-compatible browsers, a single input field is displayed. On the SWF platform, the
	 * basic:DateField is used.
	 *
	 * As of Oct 30, 2017, Safari and Internet Explorer do not support the HTML5 input 'date'.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */

	COMPILE::JS
	public class DateField extends org.apache.royale.html.DateField
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override protected function createElement():WrappedHTMLElement
        {
			var wrapper:WrappedHTMLElement = addElementToWrapper(this,'input');
			this.element.setAttribute('type','date');

			var detected:String = this.element["type"];
			if (detected != "date") { // does not support HTML5 <input type="date" />
				return super.createElement();
			}

			this.element.addEventListener("change", handleDateSelection);

			return wrapper;
        }

        private var _selectedDate:Date;

        [Bindable("selectedDateChanged")]

        /**
         * The date currently displayed by the DateField.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
        override public function get selectedDate():Date
        {
        	return _selectedDate;
        }
        override public function set selectedDate(value:Date):void
        {
        	_selectedDate = value;
        	this.element["valueAsDate"] = value;

        	dispatchEvent(new Event("selectedDateChanged"));
        }

		/**
		 * @private
		 */
        private function handleDateSelection(event:Event):void
        {
        	var item:Object = event.target.value;
        	_selectedDate = new Date(item);

			this.element.removeEventListener("change", handleDateSelection);
        	dispatchEvent(new Event("change"));
			this.element.addEventListener("change", handleDateSelection);
        }

	}

	COMPILE::SWF
	public class DateField extends org.apache.royale.html.DateField
	{
	}
}
