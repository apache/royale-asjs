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
package org.apache.royale.utils
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.effects.Effect;
	import org.apache.royale.effects.IEffect;
	import org.apache.royale.effects.Parallel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	/**
	 *
	 * @author Yishay
	 */
	public class LayoutTweener extends EventDispatcher
	{
		private var sourceLayout:IBeadLayout;
		private var sourceLayoutParent:ILayoutParent;
		private var _mockLayoutParent:MockLayoutParent;
		private var _effectGenerators:Vector.<IEffectsGenerator>;
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

		public function get effectGenerators():Vector.<IEffectsGenerator>
		{
			return _effectGenerators;
		}

		public function set effectGenerators(value:Vector.<IEffectsGenerator>):void
		{
			_effectGenerators = value;
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
			var originalContentView:ILayoutView = originalLayoutParent.getLayoutHost().contentView;
			var mockContentView:ILayoutView = mockLayoutParent.getLayoutHost().contentView;
			var numElements:int = originalContentView.numElements;
			var effects:Array = [];
			for (var i:int = 0; i < numElements; i++)
			{
				var originalChild:ILayoutChild = originalContentView.getElementAt(i) as ILayoutChild;
				var mockChild:ILayoutChild = mockContentView.getElementAt(i) as ILayoutChild;
				for (var j:int = 0; j < effectGenerators.length; j++)
				{
					var effect:IEffect = effectGenerators[j].generateEffect(originalChild, mockChild);
					if (effect)
					{
						effects.push(effect);
					}
				}
			}
			return effects;
		}

	}
}
