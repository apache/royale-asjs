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
package org.apache.flex.utils
{
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.effects.Effect;
	import org.apache.flex.effects.Move;
	import org.apache.flex.effects.Parallel;
	import org.apache.flex.effects.Resize;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;

	/**
	 * 
	 * @author Yishay
	 */
	public class LayoutTweener extends EventDispatcher
	{
		private var sourceLayout:IBeadLayout;
		private var sourceLayoutParent:ILayoutParent;
		private var _mockLayoutParent:MockLayoutParent;
		/**
		 * 
		 * @param sourceLayout
		 * @param sourceLayoutParent
		 */
		public function LayoutTweener(sourceLayout:IBeadLayout, sourceLayoutParent:ILayoutParent)
		{
			this.sourceLayout = sourceLayout;
			this.sourceLayoutParent = sourceLayoutParent;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function get mockLayoutParent():MockLayoutParent
		{
			return _mockLayoutParent;
		}

		/**
		 * 
		 */
		public function setBaseline():void
		{
			_mockLayoutParent = new MockLayoutParent(sourceLayoutParent);
			sourceLayout.strand = _mockLayoutParent as IStrand;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function layout():Boolean
		{
			setBaseline();
			var result:Boolean = sourceLayout.layout();
			play();
			return result;
		}
		
		/**
		 * 
		 */
		public function play():void
		{
			var effects:Array = getEffects(sourceLayoutParent, mockLayoutParent);
			_mockLayoutParent = null;
			sourceLayout.strand = sourceLayoutParent as IStrand;
			if (effects && effects.length > 0)
			{
				var parallel:Parallel = new Parallel();
				parallel.children = effects;
				parallel.addEventListener(Effect.EFFECT_END, effectEndHandler);
				parallel.play();
			}
		}
		
		/**
		 * 
		 * @param event
		 */
		protected function effectEndHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
		private function getEffects(originalLayoutParent:ILayoutParent, mockLayoutParent:ILayoutParent):Array
		{
			var originalContentView:IParentIUIBase = originalLayoutParent.getLayoutHost().contentView;
			var mockContentView:IParentIUIBase = mockLayoutParent.getLayoutHost().contentView;
			var numElements:int = originalContentView.numElements;
			var effects:Array = [];
			for (var i:int = 0; i < numElements; i++)
			{
				var originalChild:ILayoutChild = originalContentView.getElementAt(i) as ILayoutChild;
				var mockChild:ILayoutChild = mockContentView.getElementAt(i) as ILayoutChild;
				pushMove(originalChild, mockChild, effects);
				pushResize(originalChild, mockChild, effects);
			}
			return effects;
		}
		
		private function pushResize(originalChild:ILayoutChild, mockChild:ILayoutChild, effects:Array):void
		{
			var widthDiff:Number = mockChild.width - originalChild.width;
			var heightDiff:Number = mockChild.height - originalChild.height;
			if (widthDiff != 0 || heightDiff !=0)
			{
				var resize:Resize = new Resize(originalChild as IUIBase);
				resize.widthBy = widthDiff;
				resize.heightBy = heightDiff;
				effects.push(resize);
			}
		}
		
		private function pushMove(originalChild:ILayoutChild, mockChild:ILayoutChild, effects:Array):void
		{
			var xDiff:Number = mockChild.x - originalChild.x;
			var yDiff:Number = mockChild.y - originalChild.y;
			if (xDiff != 0 || yDiff !=0)
			{
				var move:Move = new Move(originalChild as IUIBase);
				move.xBy = xDiff;
				move.yBy = yDiff;
				effects.push(move);
			}
		}
		
	}
}