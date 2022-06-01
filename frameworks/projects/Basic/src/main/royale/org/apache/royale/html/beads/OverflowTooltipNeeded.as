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

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.WrappedHTMLElement;

	/**
	 *  The OverflowTooltipNeeded class is a bead that can be used 
	 *  to trigger an event when there's an overflow and a tooltip is needed
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	COMPILE::JS
	public class OverflowTooltipNeeded implements IBead
	{
		public static const TOOL_TIP_NEEDED:String = "toolTipNeeded";

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			(value as IEventDispatcher).addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler)
		}

		/**
		 * Private
		 */
		private function mouseOverHandler(event:MouseEvent):void
		{

			var element:WrappedHTMLElement = (_strand as IUIBase).element;
			var style:CSSStyleDeclaration = element.style;
			var tooltipNeeded:Boolean = style.textOverflow == "ellipsis" && element.offsetWidth < element.scrollWidth;
			(_strand as IEventDispatcher).dispatchEvent(new ValueEvent(TOOL_TIP_NEEDED, tooltipNeeded));
		}
	}
}