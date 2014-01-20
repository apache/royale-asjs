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
package org.apache.flex.html.staticControls.beads.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	public class ButtonBarLayout implements IBeadLayout
	{
		public function ButtonBarLayout()
		{
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("widthChanged", changeHandler);
			IEventDispatcher(value).addEventListener("childrenAdded", changeHandler);
			IEventDispatcher(value).addEventListener("itemsCreated", changeHandler);
		}
		
		private var _buttonWidths:Array = null;
		public function get buttonWidths():Array
		{
			return _buttonWidths;
		}
		public function set buttonWidths(value:Array):void
		{
			_buttonWidths = value;
		}
		
		private function changeHandler(event:Event):void
		{
			var layoutParent:ILayoutParent = _strand.getBeadByType(ILayoutParent) as ILayoutParent;
			var contentView:DisplayObjectContainer = layoutParent.contentView;
			
			var n:int = contentView.numChildren;
			var xpos:Number = 0;
			var useWidth:Number = DisplayObject(_strand).width / n;
			var useHeight:Number = DisplayObject(_strand).height;
			
			for (var i:int = 0; i < n; i++)
			{
				var child:DisplayObject = contentView.getChildAt(i);
				
				child.y = 0;
				child.height = useHeight;
				child.x = xpos;
				
				if (buttonWidths) child.width = Number(buttonWidths[i]);
				else child.width = useWidth;
				xpos += child.width;
			}
		}
	}
}