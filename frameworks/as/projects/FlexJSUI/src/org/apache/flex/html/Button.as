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
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIButtonBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.IEventDispatcher;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the user clicks on a button.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="click", type="org.apache.flex.events.Event")]

    /**
     *  The Button class is a simple button.  Use TextButton for
     *  buttons that should show text.  This is the lightest weight
     *  button used for non-text buttons like the arrow buttons
     *  in a Scrollbar or NumericStepper.
     * 
     *  The most common view for this button is CSSButtonView that
     *  allows you to specify a backgroundImage in CSS that defines
     *  the look of the button.
     * 
     *  However, when used in ScrollBar and when composed in many
     *  other components, it is more common to assign a custom view
     *  to the button.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class Button extends UIButtonBase implements IStrand, IEventDispatcher, IUIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Button()
		{
			super();
		}	
		
		/**
		 * @private
		 */
		override public function get width():Number
		{
			var useWidth:Number;
			if (isNaN(this.explicitWidth)) {
				var padding:Object = ValuesManager.valuesImpl.getValue(this,"padding");
				if (padding == null) padding = 0;
				var borderThickness:Object = ValuesManager.valuesImpl.getValue(this,"border-thickness");
				if (borderThickness == null) borderThickness = 0;
				var paddingLeft:Object = ValuesManager.valuesImpl.getValue(this,"padding-left");
				if (paddingLeft == null) paddingLeft = padding;
				var paddingRight:Object = ValuesManager.valuesImpl.getValue(this,"padding-right");
				if (paddingRight == null) paddingRight = padding;
				useWidth = super.width + paddingLeft + paddingRight + 2*Number(borderThickness);
			}
			else {
				useWidth = this.explicitWidth;
			}
			return useWidth;
		}
		
		/**
		 * @private
		 */
		override public function get height():Number
		{
			var useHeight:Number;
			if (isNaN(this.explicitHeight)) {
				var padding:Object = ValuesManager.valuesImpl.getValue(this,"padding");
				if (padding == null) padding = 0;
				var borderThickness:Object = ValuesManager.valuesImpl.getValue(this,"border-thickness");
				if (borderThickness == null) borderThickness = 0;
				var paddingTop:Object = ValuesManager.valuesImpl.getValue(this,"padding-top");
				if (paddingTop == null) paddingTop = padding;
				var paddingBottom:Object = ValuesManager.valuesImpl.getValue(this,"padding-bottom");
				if (paddingBottom == null) paddingBottom = padding;
				useHeight = super.height + paddingTop + paddingBottom + 2*Number(borderThickness);
			}
			else {
				useHeight = this.explicitHeight;
			}
			return useHeight;
		}
	}
}
