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

package mx.containers.beads
{
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IUIComponent;
	
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.LayoutBase;
	
	public class BasicLayout extends LayoutBase
	{
		public function BasicLayout()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		private var _strand:IStrand;
		
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			_target = value as Container;
			super.strand = value;
			
		}
		
		private var _target:Container;
		
		public function get target():Container
		{
			return _target;
		}
		
		public function set target(value:Container):void
		{
			_target = value;
		}
		
		override public function layout():Boolean
		{
			var testWidth:Number = target.getExplicitOrMeasuredWidth();
			var testHeight:Number = target.getExplicitOrMeasuredHeight();
			trace("Before layout: width="+testWidth+"; height="+testHeight);
			if (updateDisplayList(target.width, target.height)) {
				testWidth = target.getExplicitOrMeasuredWidth();
				testHeight = target.getExplicitOrMeasuredHeight();
				//???	target.setActualSize(testWidth, testHeight);
				trace("After layout: width="+target.width+"; height="+target.height);
				
			}
			return true;
		}
		
		/**
		 *  @private
		 *  Lay out the children using their x, y positions
		 */
		public function updateDisplayList(unscaledWidth:Number,
										  unscaledHeight:Number):Boolean
		{			
			var n:int = target.numChildren;
			if (n == 0)
				return false;
			
			COMPILE::JS {
				if (target.positioner.style.position != 'absolute' || target.positioner.style.position != 'relative') {
					target.positioner.style.position = 'relative';
				}
			}
			
			var i:int;
			var obj:Object;
			
			for(i=0; i < n; i++) {
				obj = target.getLayoutChildAt(i);
				if (obj.includeInLayout) {
					COMPILE::JS {
						obj.positioner.style.position = 'absolute';
					}
				}
			}
			
			return true;
		}
	}
}