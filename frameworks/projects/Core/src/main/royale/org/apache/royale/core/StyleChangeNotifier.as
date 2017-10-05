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
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.events.StyleChangeEvent;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStyleableObject;
	
	/**
	 * The StyleChangeNotifier can be added to the bead list of any UI component
	 * that needs to react to dynamic changes to its styles.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
	 */
	public class StyleChangeNotifier implements IBead
	{
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{	
			_strand = value;
			
			var style:Object = IStyleableObject(value).style as IEventDispatcher;
			if (style) {
				IEventDispatcher(style).addEventListener(ValueChangeEvent.VALUE_CHANGE, handleStyleChange);
			}
		}
		
		/**
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 *  @royaleignorecoercion org.apache.royale.core.UIHTMLElementWrapper
		 */
		private function handleStyleChange(event:ValueChangeEvent):void
		{
			COMPILE::SWF {
				var styleEvent:StyleChangeEvent = StyleChangeEvent.createChangeEvent(_strand, event.propertyName, event.oldValue, event.newValue);
				IEventDispatcher(_strand).dispatchEvent(styleEvent);
			}
			COMPILE::JS {
				var host:UIHTMLElementWrapper = UIHTMLElementWrapper(_strand);
				if (host) {
					var element:WrappedHTMLElement = host.element as WrappedHTMLElement;
					if (element) {
						element.style[event.propertyName] = event.newValue;
					}
				}
			}
		}
	}
}
