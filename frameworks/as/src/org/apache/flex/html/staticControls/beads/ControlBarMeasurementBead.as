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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.html.staticControls.Container;
	
	public class ControlBarMeasurementBead implements IMeasurementBead
	{
		public function ControlBarMeasurementBead()
		{
		}
		
		public function get measuredWidth():Number
		{
			// Note: the measurement should problably be done by the ControlBar's layout manager bead
			// since it would know the arrangement of the items and how far apart they are and if
			// there are margins and paddings and gaps involved.
			var mwidth:Number = 0;
			var children:Array = Container(_strand).getChildren();
			var n:int = children.length;
			for(var i:int=0; i < n; i++) {
				var child:IUIBase = children[i] as IUIBase;
				if( child == null ) continue;
				var childMeasure:IMeasurementBead = child.measurementBead;
				mwidth += childMeasure.measuredWidth;
			}
			return mwidth;
		}
		
		public function get measuredHeight():Number
		{
			// Note: the measurement should problably be done by the ControlBar's layout manager bead
			// since it would know the arrangement of the items and how far apart they are and if
			// there are margins and paddings and gaps involved.
			var mheight:Number = 0;
			var n:int = DisplayObjectContainer(_strand).numChildren;
			for(var i:int=0; i < n; i++) {
				var child:IUIBase = DisplayObjectContainer(_strand).getChildAt(i) as IUIBase;
				if( child == null ) continue;
				var childMeasure:IMeasurementBead = child.measurementBead;
				mheight += childMeasure.measuredHeight;
			}
			return mheight;
		}
		
		private var _strand:IStrand;
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
	}
}