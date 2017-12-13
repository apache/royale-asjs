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
    import org.apache.royale.core.ISelectable;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IToggleButtonModel;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
    COMPILE::SWF
    {
        import flash.events.MouseEvent;
        import org.apache.royale.core.UIButtonBase;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.supportClasses.CheckBoxIcon;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when the user checks or un-checks the CSSCheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    /**
     *  The CSSCheckBox class implements the common user interface
     *  control.  The CSSCheckBox includes its text label and is styleable using CSS.
     * To style the checkbox control, a `checkClassName` should be specified which corresponds to a CSS class name.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class CSSCheckBox extends UIButtonBase implements IStrand, ISelectable
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CSSCheckBox()
		{
			super();

			addEventListener(org.apache.royale.events.MouseEvent.CLICK, internalMouseHandler);
		}

        /**
         *  The text label for the CSSCheckBox.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
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

		private function internalMouseHandler(event:org.apache.royale.events.MouseEvent) : void
		{
			selected = !selected;
			dispatchEvent(new Event("change"));
		}
        private var _checkClassName:String;
        public function get checkClassName():String
        {
            return _checkClassName;
        }
        public function set checkClassName(value:String):void
        {
            _checkClassName = value;
        }
        
	}

    /**
     *  Dispatched when the user checks or un-checks the CSSCheckBox.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	[Event(name="change", type="org.apache.royale.events.Event")]

    COMPILE::JS
    public class CSSCheckBox extends UIBase implements ISelectable
    {

		private var _label:WrappedHTMLElement;
		private var _icon:CheckBoxIcon;
		private var _styleDiv:WrappedHTMLElement;
        private var _textNode:WrappedHTMLElement

		private static var _checkNumber:Number = 0;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'label');
			_label = element;
			_icon = new CheckBoxIcon();
            element.appendChild(_icon.element);
            // Add a span to allow checkbox styling
            _styleDiv = document.createElement('div') as WrappedHTMLElement;
            if(_checkClassName)
                _styleDiv.setAttribute("class",_checkClassName)
            element.appendChild(_styleDiv);
            _textNode = document.createTextNode('') as WrappedHTMLElement;
            element.appendChild(_textNode);
            //positioner.style.position = 'relative';
			_icon.element.royale_wrapper = this;
            _styleDiv.royale_wrapper = this;

            className = 'CSSCheckBox';
            typeNames = 'CSSCheckBox';

            return element;
        }

        private var _checkClassName:String;
        public function get checkClassName():String
        {
            return _checkClassName;
        }
        public function set checkClassName(value:String):void
        {
            _checkClassName = value;
            if(_styleDiv)
                _styleDiv.setAttribute("class",_checkClassName);
        }

        public function get text():String
        {
            return _textNode.nodeValue;
        }

        public function set text(value:String):void
        {
            _textNode.nodeValue = value;
        }

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
