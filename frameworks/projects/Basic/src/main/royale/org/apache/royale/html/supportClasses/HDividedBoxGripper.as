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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.svg.Rect;

	/**
	 * The HDividedBoxGripper is a bead added to the HDividedBoxDivider to
	 * provide a visual cue that the divider can be grabbed and moved.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class HDividedBoxGripper implements IBead, IDividedBoxGripper
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function HDividedBoxGripper()
		{
		}
		
		private var _strand:IStrand;
		private var rect:Rect;
		
		/**
		 * @copy org.apache.royale.core.IStrand#strand
		 * 
		 * @royaleignorecoercion UIBase
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS {
				(_strand as UIBase).element.style.cursor = 'col-resize';
			}
			
			(_strand as IEventDispatcher).addEventListener("widthChanged", handleResize);
			(_strand as IEventDispatcher).addEventListener("heightChanged", handleResize);
			
			rect = new Rect();
			rect.fill = new SolidColor(0x555555);
			(_strand as UIBase).addElement(rect);
		}
		
		/**
		 * @private
		 */
		private function handleResize(event:Event):void
		{
			var useWidth:Number = (_strand as UIBase).width;
			var useHeight:Number = (_strand as UIBase).height;
			
			// for horizontal gripper, it is taller than it is wide
			rect.width = useWidth - 2;
			rect.height = rect.width * 4;
			
			rect.x = 1;
			rect.y = (useHeight - rect.height)/2;
			rect.draw();
		}
	}
}