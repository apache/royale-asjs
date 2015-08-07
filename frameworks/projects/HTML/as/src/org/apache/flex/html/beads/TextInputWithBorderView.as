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
package org.apache.flex.html.beads
{
	import flash.display.DisplayObject;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
    import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.supportClasses.Border;
	import org.apache.flex.utils.BeadMetrics;

    /**
     *  The TextInputWithBorderView class is the default view for
     *  the org.apache.flex.html.TextInput.
     *  It displays text using a TextField, so there is no
     *  right-to-left text support in this view.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
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
		}

        /**
         *  Determine the width of the TextField.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        override protected function widthChangeHandler(event:Event):void
        {
            if (!inWidthChange)
            {
                textField.autoSize = "none";
                autoWidth = false;
                var uiMetrics:UIMetrics = BeadMetrics.getMetrics(host);
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
         *  @productversion FlexJS 0.0
         */
        override protected function sizeChangeHandler(event:Event):void
        {
            super.sizeChangeHandler(event);
            widthChangeHandler(event);
        }
    }
}
