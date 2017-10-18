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
package org.apache.royale.core
{
	COMPILE::SWF {
        import flash.display.DisplayObject;
        import flash.text.TextField;
        import flash.text.TextFieldAutoSize;
        import flash.text.TextFormat;
        
        import org.apache.royale.events.Event;
        import org.apache.royale.events.EventDispatcher;
	}

    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.utils.CSSUtils;

    /**
     *  The CSSTextField class implements CSS text styles in a TextField.
     *  Not every CSS text style is currently supported.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class CSSTextField extends TextField implements IRenderedObject
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CSSTextField()
		{
		}

        /**
         *  @private
         *  The styleParent property is set if the CSSTextField
         *  is used in a SimpleButton-based instance because
         *  the parent property is null, defeating CSS lookup.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public var styleParent:Object;

        /**
         *  @private
         *  The CSS pseudo-state for lookups.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var styleState:String;

        /**
         *  @private
         *  The parentDrawsBackground property is set if the CSSTextField
         *  shouldn't draw a background
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var parentDrawsBackground:Boolean;

        /**
         *  @private
         *  The parentHandlesPadding property is set if the CSSTextField
         *  shouldn't worry about padding
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var parentHandlesPadding:Boolean;

        /**
         *  @private
         */
		override public function set text(value:String):void
		{
			var sp:Object = parent;
            if (sp is IRoyaleElement)
                sp = sp.royale_wrapper;
			if (styleParent)
				sp = styleParent;
			sp.addEventListener("classNameChanged", updateStyles);

			var tf: TextFormat = new TextFormat();
			tf.font = ValuesManager.valuesImpl.getValue(sp, "fontFamily", styleState) as String;
			tf.size = ValuesManager.valuesImpl.getValue(sp, "fontSize", styleState);
			tf.bold = ValuesManager.valuesImpl.getValue(sp, "fontWeight", styleState) == "bold";
			tf.color = CSSUtils.toColor(ValuesManager.valuesImpl.getValue(sp, "color", styleState));
            if (!parentHandlesPadding)
            {
        		var padding:Object = ValuesManager.valuesImpl.getValue(sp, "padding", styleState);
        		var paddingLeft:Object = ValuesManager.valuesImpl.getValue(sp,"padding-left", styleState);
        		var paddingRight:Object = ValuesManager.valuesImpl.getValue(sp,"padding-right", styleState);
        		tf.leftMargin = CSSUtils.getLeftValue(paddingLeft, padding, width);
        		tf.rightMargin = CSSUtils.getRightValue(paddingRight, padding, width);
            }
            var align:Object = ValuesManager.valuesImpl.getValue(sp, "text-align", styleState);
            if (align == "center")
			{
				autoSize = TextFieldAutoSize.NONE;
                tf.align = "center";
			}
            else if (align == "right")
			{
                tf.align = "right";
				autoSize = TextFieldAutoSize.NONE;
			}
            if (!parentDrawsBackground)
            {
                var backgroundColor:Object = ValuesManager.valuesImpl.getValue(sp, "background-color", styleState);
                if (backgroundColor != null)
                {
                    background = true;
                    this.backgroundColor = CSSUtils.toColor(backgroundColor);
                }
				
				// supports border: <thickness> solid <color> 
				var border:Object = ValuesManager.valuesImpl.getValue(sp, "border", styleState);
				if (border != null && border is Array) {
					this.border = true;
					this.borderColor = CSSUtils.toColor(border[2]);
					this.thickness = Number(border[0]);
				}
				// else: add code to look for individual border styles such as border-color.
            }
			defaultTextFormat = tf;
			super.text = value;
		}

        private function updateStyles(event:Event):void
        {
            // force styles to be re-calculated
            this.text = text;
        }
		
		COMPILE::SWF
		public function get $displayObject():DisplayObject
		{
			return this;
		}
		
	}
}
