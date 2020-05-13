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
package org.apache.royale.jewel.itemRenderers
{
    COMPILE::SWF
    {
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	import org.apache.royale.core.CSSTextField;
    }
    COMPILE::JS
    {
	import org.apache.royale.core.WrappedHTMLElement;
	import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IOwnerViewItemRenderer;
    import org.apache.royale.html.supportClasses.StyledDataItemRenderer;
    import org.apache.royale.html.util.getLabelFromData;
    import org.apache.royale.jewel.beads.controls.TextAlign;
    import org.apache.royale.jewel.beads.itemRenderers.IAlignItemRenderer;
    import org.apache.royale.jewel.beads.itemRenderers.ITextItemRenderer;

	/**
	 *  The StringItemRenderer class displays data in string form using the data's toString()
	 *  function.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class StringItemRenderer extends StyledDataItemRenderer implements IOwnerViewItemRenderer, ITextItemRenderer, IAlignItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function StringItemRenderer()
		{
			super();

            typeNames = "jewel item string";

            COMPILE::SWF
            {
                textField = new CSSTextField();
                textField.type = TextFieldType.DYNAMIC;
                textField.autoSize = TextFieldAutoSize.LEFT;
                textField.selectable = false;
                textField.parentDrawsBackground = true;
            }

			textAlign = new TextAlign();
			addBead(textAlign);
		}

		private var textAlign:TextAlign;

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

		}

		/**
		 *  The text currently displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get text():String
		{
            COMPILE::SWF
            {
                return textField.text;
            }
            COMPILE::JS
            {
                return this.element.textContent;
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
                this.element.textContent = value;
            }
		}

		/**
		 *  How text align in the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get align():String
		{
			return textAlign.align;
		}
		public function set align(value:String):void
		{
			textAlign.align = value;
		}

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion String
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
            text = getLabelFromData(this, value);
		}

        // COMPILE::JS
        // private var backgroundView:WrappedHTMLElement;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'span');
            // itemRenderers should provide something for the background to handle
            // the selection and highlight
            // backgroundView = element;
            // return element;
        }

        /*
		 * IItemRenderer, ISelectableItemRenderer
		 */
		private var _itemRendererOwnerView:IItemRendererOwnerView;
		/**
		 * The parent container for the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get itemRendererOwnerView():IItemRendererOwnerView
		{
			return _itemRendererOwnerView;
		}
		public function set itemRendererOwnerView(value:IItemRendererOwnerView):void
		{
			_itemRendererOwnerView = value;
		}
	}
}
