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
package org.apache.royale.html.beads
{
    import org.apache.royale.html.beads.TextFieldViewBase;
	import flash.display.DisplayObject;
	import flash.text.TextFieldType;
	
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.geom.Rectangle;
	
    /**
     *  The TextInputView class is the view for
     *  the org.apache.royale.html.TextInput in
     *  a ComboBox and other controls 
     *  because it does not display a border.
     *  It displays text using a TextField, so there is no
     *  right-to-left text support in this view.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class TextInputView extends TextFieldViewBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function TextInputView()
		{
			super();
			
			textField.selectable = true;
			textField.type = TextFieldType.INPUT;
			textField.mouseEnabled = true;
			textField.multiline = false;
			textField.wordWrap = false;
		}
		
        /**
         *  @private
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            autoWidth = autoHeight = false;

            var w:Number;
            var h:Number;
            var uiMetrics:EdgeData;
            var ilc:ILayoutChild = host as ILayoutChild;
            if (ilc.isWidthSizedToContent())
            {
                uiMetrics = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(host);
                // use default width of 20
                var s:String = textField.text;
                textField.text = "0";
                w = textField.textWidth * 20;
                h = textField.textHeight;
                textField.text = s;
                ilc.setWidth(w + uiMetrics.left + uiMetrics.right, true);
				// TextInput doesn't stretch if no width like divs do
				ilc.explicitWidth = ilc.width;
            }
            if (ilc.isHeightSizedToContent())
            {
                if (!uiMetrics)
                    uiMetrics = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(host);
                if (isNaN(h))
                {
                    s = textField.text;
                    textField.text = "0";
                    h = textField.textHeight;
                    textField.text = s;                    
                }
                ilc.setHeight(h + uiMetrics.top + uiMetrics.bottom, true);
				// TextInput doesn't stretch if no height like divs do
				ilc.explicitHeight = ilc.height;
            }
			
			heightChangeHandler(null);
		}
		
        /**
         *  @private
         */
        override protected function heightChangeHandler(event:Event):void
		{
			var hh:Number = host.height;
			if( !isNaN(hh) && hh > 0 ) 
            {
                textField.height = textField.textHeight + 5;
            }
            
            textField.y = ((hh - textField.height) / 2);
		}
        
        /**
         *  @private
         */
        override protected function sizeChangeHandler(event:Event):void
        {
            var ww:Number = host.width;
            if( !isNaN(ww) && ww > 0 ) textField.width = ww;
            
            var hh:Number = host.height;
            if( !isNaN(hh) && hh > 0 ) 
            {
                textField.height = textField.textHeight + 5;
                textField.y = ((hh - textField.height) / 2);
            }
        }
	}
}
