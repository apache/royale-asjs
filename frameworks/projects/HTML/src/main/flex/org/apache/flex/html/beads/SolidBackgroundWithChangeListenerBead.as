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
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.ValueChangeEvent;
	import org.apache.flex.utils.CSSUtils;
	
	COMPILE::SWF {
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.BindableCSSStyles;
	import org.apache.flex.html.beads.SolidBackgroundBead;
	}
		
	COMPILE::JS {
	import org.apache.flex.core.WrappedHTMLElement;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	}
	
	/**
	 * Same as SolidBackgroundBead except it adds an event listener on a bindable style
	 * (eg, BindableCSSStyles) to detect changes in some of its properties and then
	 * apply those changes to itself.
	 * 
	 * Usage: <js:SolidBackgroundWithChangeListenerBead style="{bindableCSSStylesbead}" />
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	COMPILE::SWF
	public class SolidBackgroundWithChangeListenerBead extends SolidBackgroundBead
	{
		/**
		 * Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		public function SolidBackgroundWithChangeListenerBead()
		{
			super();
		}
		
		/**
		 * @private
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
		}
		
		private var _style:IEventDispatcher;
		
		/**
		 * The bindable style to use as the source of the changes.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
		 */
		public function get style():IEventDispatcher
		{
			return _style;
		}
		public function set style(value:IEventDispatcher):void
		{
			_style = value;
			if (_style) {
				_style.addEventListener(ValueChangeEvent.VALUE_CHANGE, handleStyleChange);
			}
		}
		
		/**
		 * @private
		 */
		private function handleStyleChange(event:ValueChangeEvent):void
		{
			if (event.propertyName == "backgroundColor") {
				var valueAsNumber:uint;
				if (event.newValue is String) {
					valueAsNumber = CSSUtils.toColor(event.newValue);
				} else {
					valueAsNumber = event.newValue as uint;
				}
				this[event.propertyName] = valueAsNumber;
			}
		}
	}
	
	COMPILE::JS
	public class SolidBackgroundWithChangeListenerBead implements IBead
	{
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{	
			_strand = value;
		}
		
		private var _style:IEventDispatcher;
		
		/**
		 * The bindable style to use as the source of the changes.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get style():IEventDispatcher
		{
			return _style;
		}
		public function set style(value:IEventDispatcher):void
		{
			_style = value;
			if (_style) {
				_style.addEventListener(ValueChangeEvent.VALUE_CHANGE, handleStyleChange);
			}
		}
		
		/**
		 * @private
		 *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 *  @flexjsignorecoercion UIBase
		 */
		private function handleStyleChange(event:ValueChangeEvent):void
		{
			var host:UIBase = UIBase(_strand);
			var element:WrappedHTMLElement = host.element as WrappedHTMLElement;
			
			// For HTML/CSS, the color change value should be expressed as a hex string. It
			// can be other things, but using element.style.backgroundColor requires a hex string.
			if (event.propertyName === "backgroundColor") {
				var valueAsString:String;
				if (event.newValue is Number) {
					valueAsString = CSSUtils.attributeFromColor(event.newValue as uint);
				} else {
					valueAsString = event.newValue as String;
				}
				element.style.backgroundColor = valueAsString;
			}
		}
	}
}