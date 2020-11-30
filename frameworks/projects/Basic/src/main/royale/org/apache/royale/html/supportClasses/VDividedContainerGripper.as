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
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.graphics.SolidColorStroke;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.svg.Path;

	/**
	 * The VDividedContainerGripper bead adds a visual cue to the VDividedContainerDivider to
	 * indicate where to start dragging to change the size of the elements.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class VDividedContainerGripper extends Bead implements IDividedContainerGripper
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function VDividedContainerGripper()
		{
		}

		private var path:Path;

		/**
		 * @copy org.apache.royale.core.IStrand#strand
		 *
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;

			COMPILE::JS {
				(_strand as UIBase).element.style.cursor = 'row-resize';
			}
			listenOnStrand("widthChanged", handleResize);
			listenOnStrand("heightChanged", handleResize);

			path = new Path();
			path.stroke = new SolidColorStroke(0x555555,1);
			path.data = "M 0 1 L 30 1 M 0 4 L 30 4 M 0 7 L 30 7";
			(_strand as UIBase).addElement(path);
		}

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function handleResize(event:Event):void
		{
			var useWidth:Number = (_strand as UIBase).width;
			var useHeight:Number = (_strand as UIBase).height;

			path.width = 30;
			path.height = 8;
			path.x = (useWidth - path.width)/2;
			path.y = (useHeight - path.height)/2;
			path.draw();
		}
	}
}
