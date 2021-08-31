
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
package org.apache.royale.svg.beads
{
	import org.apache.royale.core.ImageViewBase;
	COMPILE::JS
		{
			import org.apache.royale.core.UIBase;
			import org.apache.royale.core.ValuesManager;
		}
	
	/**
	 *  The ImageView class creates the visual elements of the org.apache.royale.svg.Image component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ImageView extends ImageViewBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ImageView()
		{
		}
		
		/**
		 *  @royaleignorecoercion HTMLElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		COMPILE::JS
		override protected function sizeChangedHandler(event:Object):void
		{
			super.sizeChangedHandler(event);
			var host:UIBase = _strand as UIBase;
			
			var left:* = ValuesManager.valuesImpl.getValue(host, "left");
			var right:* = ValuesManager.valuesImpl.getValue(host, "right");
			var l:Number = isNaN(left) ? NaN : left;
			var r:Number = isNaN(right) ? NaN : right;

			var top:* = ValuesManager.valuesImpl.getValue(host, "top");
			var bottom:* = ValuesManager.valuesImpl.getValue(host, "bottom");
			var t:Number = isNaN(top) ? NaN : top;
			var b:Number = isNaN(bottom) ? NaN : bottom;
			
			var p:Object = host.positioner;

			if (!isNaN(l) &&
				!isNaN(r)) {
				// if just using size constraints and image will not shrink or grow
				var computedWidth:Number = (host.positioner.offsetParent as HTMLElement).offsetWidth -
					l - r;
				p.setAttribute("width", computedWidth);

			}
			if (!isNaN(t) &&
				!isNaN(b)) {
				// if just using size constraints and image will not shrink or grow
				var computedHeight:Number = (host.positioner.offsetParent as HTMLElement).offsetHeight -
					t - b;
				p.setAttribute("height", computedHeight);
			}
		}

	}
}
