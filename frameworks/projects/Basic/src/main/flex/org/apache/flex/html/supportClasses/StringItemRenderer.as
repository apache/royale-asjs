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
package org.apache.flex.html.supportClasses
{
    COMPILE::SWF
    {
        import flash.text.TextFieldAutoSize;
        import flash.text.TextFieldType;

        import org.apache.flex.core.CSSTextField;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.beads.controllers.ItemRendererMouseController;
    }
    import org.apache.flex.events.Event;
    import org.apache.flex.html.beads.ITextItemRenderer;

	/**
	 *  The StringItemRenderer class displays data in string form using the data's toString()
	 *  function.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StringItemRenderer extends DataItemRenderer implements ITextItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function StringItemRenderer()
		{
			super();

            COMPILE::SWF
            {
                textField = new CSSTextField();
                textField.type = TextFieldType.DYNAMIC;
                textField.autoSize = TextFieldAutoSize.LEFT;
                textField.selectable = false;
                textField.parentDrawsBackground = true;
            }
		}

        COMPILE::SWF
		public var textField:CSSTextField;

		/**
		 * @private
		 */
        COMPILE::SWF
		override public function addedToParent():void
		{
			super.addedToParent();

			addChild(textField);

			adjustSize();
		}

		/**
		 * @private
		 */
        COMPILE::SWF
		override public function adjustSize():void
		{
			var cy:Number = height/2;

			textField.x = 0;
			textField.y = cy - textField.height/2;
			textField.width = width;

			updateRenderer();
		}

		/**
		 *  The text currently displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get text():String
		{
            COMPILE::SWF
            {
                return textField.text;
            }
            COMPILE::JS
            {
                return this.element.innerHTML;
            }
		}

		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                textField.text = value;
            }
            COMPILE::JS
            {
                this.element.innerHTML = value;
            }
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
            var text:String;
			if (labelField) text = String(value[labelField]);
			else if (dataField) text = String(value[dataField]);
			else text = String(value);

            this.text = text;
		}

        COMPILE::JS
        private var controller:ItemRendererMouseController;

        COMPILE::JS
        private var backgroundView:WrappedHTMLElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            element = document.createElement('span') as WrappedHTMLElement;
            positioner = element;
            //positioner.style.position = 'relative';

            element.flexjs_wrapper = this;
            className = 'StringItemRenderer';

            // itemRenderers should provide something for the background to handle
            // the selection and highlight
            backgroundView = element;

            return element;
        }

	}
}
