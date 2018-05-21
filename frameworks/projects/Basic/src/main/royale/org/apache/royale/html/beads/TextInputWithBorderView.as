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
package org.apache.royale.html.beads
{
	import flash.display.DisplayObject;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.supportClasses.Border;

    /**
     *  The TextInputWithBorderView class is the default view for
     *  the org.apache.royale.html.TextInput.
     *  It displays text using a TextField, so there is no
     *  right-to-left text support in this view.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class TextInputWithBorderView extends TextInputView
	{
		public function TextInputWithBorderView()
		{
			super();
            textField.parentDrawsBackground = true;
            textField.parentHandlesPadding = true;
		}
		
        /**
         *  @private
         */        
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
            value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBackgroundBead")) as IBead);
			value.addBead(new (ValuesManager.valuesImpl.getValue(value, "iBorderBead")) as IBead);
			
			// if we aren't going to get resized, draw the border now
            var ilc:ILayoutChild = host as ILayoutChild;
            if (ilc.isWidthSizedToContent() && !isNaN(ilc.explicitHeight))
				ilc.dispatchEvent(new Event("initComplete"));
		}

        /**
         *  Determine the width of the TextField.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
         */
        override protected function widthChangeHandler(event:Event):void
        {
            if (!inWidthChange)
            {
                textField.autoSize = "none";
                autoWidth = false;
                var uiMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(host);
                textField.width = host.width - uiMetrics.left - uiMetrics.right;
                textField.x = uiMetrics.left;
            }
        }
        
        /**
         *  Determine the size of the TextField.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        override protected function sizeChangeHandler(event:Event):void
        {
            super.sizeChangeHandler(event);
            widthChangeHandler(event);
        }
    }
}
