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
package org.apache.flex.html
{
    COMPILE::SWF
    {
        import flash.events.MouseEvent;
    }

	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IToggleButtonModel;
	import org.apache.flex.core.IUIBase;
    COMPILE::SWF
    {
        import org.apache.flex.core.UIButtonBase;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.supportClasses.CheckBoxIcon;
    }
	import org.apache.flex.events.Event;
	import org.apache.flex.events.MouseEvent;

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user checks or un-checks the CheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="change", type="org.apache.flex.events.Event")]

    /**
     *  The CheckBox class implements the common user interface
     *  control.  The CheckBox includes its text label.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class CheckBox extends UIButtonBase implements IStrand
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CheckBox()
		{
			super();

			addEventListener(org.apache.flex.events.MouseEvent.CLICK, internalMouseHandler);
		}

        /**
         *  The text label for the CheckBox.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get text():String
		{
			return IToggleButtonModel(model).text;
		}

        /**
         *  @private
         */
		public function set text(value:String):void
		{
			IToggleButtonModel(model).text = value;
		}

        [Bindable("change")]
        /**
         *  <code>true</code> if the check mark is displayed.
         *
         *  @default false
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get selected():Boolean
		{
			return IToggleButtonModel(model).selected;
		}

        /**
         *  @private
         */
		public function set selected(value:Boolean):void
		{
			IToggleButtonModel(model).selected = value;
		}

		private function internalMouseHandler(event:org.apache.flex.events.MouseEvent) : void
		{
			selected = !selected;
			dispatchEvent(new Event("change"));
		}
	}

    /**
     *  Dispatched when the user checks or un-checks the CheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="change", type="org.apache.flex.events.Event")]

    COMPILE::JS
    public class CheckBox extends UIBase
    {
		private var _label:WrappedHTMLElement;
		private var _icon:CheckBoxIcon;

		private static var _checkNumber:Number = 0;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {
            var cb:HTMLInputElement;

            element = document.createElement('label') as WrappedHTMLElement;
			_label = element;
			_icon = new CheckBoxIcon();
            element.appendChild(_icon.element);

            element.appendChild(document.createTextNode(''));

            positioner = element;
            //positioner.style.position = 'relative';
            element.flexjs_wrapper = this;
			_icon.element.flexjs_wrapper = this;

            className = 'CheckBox';
            typeNames = 'CheckBox, CheckBoxIcon';

            return element;
        }

        public function get text():String
        {
            return _label.childNodes.item(1).nodeValue;
        }

        public function set text(value:String):void
        {
            _label.childNodes.item(1).nodeValue = value;
        }

        [Bindable("change")]
        public function get selected():Boolean
        {
            return (_icon.element as HTMLInputElement).checked;
        }

        public function set selected(value:Boolean):void
        {
           (_icon.element as HTMLInputElement).checked = value;
        }
    }

}
