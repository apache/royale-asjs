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
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ElementWrapper;
	import org.apache.royale.core.BeadViewBase;

	COMPILE::JS
	{
		import org.apache.royale.utils.html.getStyle;
	}
	
	/**
	 * Use AbsolutePositioningViewBeadBase as the base class for custom control view beads.
	 * This class sets the strand's position style to "relative" (HTML platform) if it is
	 * not already set to either "absolute" or "relative". Then use this class's 
	 * setAbsolutePosition(child, x, y) function to place children. The function not
	 * only set's the child's left and top styles (HTML platform), it also sets the child's
	 * position to "absolute" (HTML platform). 
	 * 
	 * On the Flash platform, this class will only set the child's x and y properties without
	 * any other side effects.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class AbsolutePositioningViewBeadBase extends BeadViewBase
	{		
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function AbsolutePositioningViewBeadBase()
		{
			super();
		}
				
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
     * @royaleignorecoercion org.apache.royale.core.ElementWrapper
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS {
				var style:CSSStyleDeclaration = getStyle(host as ElementWrapper);
				if (style.position != "absolute" && style.position != "relative") {
					style.position = "relative";
				}
			}
		}
		
		/**
		 * Sets the position of the child and, on the HTML platform, sets the child's position style
		 * value to "absolute".
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
     * @royaleignorecoercion org.apache.royale.core.ElementWrapper
     * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function setAbsolutePosition(child:IChild, x:Number, y:Number):void
		{
			var childHost:IUIBase = IUIBase(child);
			
			childHost.x = x;
			childHost.y = y;
		
			COMPILE::JS {
				getStyle(childHost as ElementWrapper).position = "absolute";
			}
		}
	}
}
