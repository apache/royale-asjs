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
package org.apache.flex.html.beads
{
	
	import flash.events.IEventDispatcher;
	
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.effects.Effect;
	import org.apache.flex.effects.Parallel;
	import org.apache.flex.effects.Resize;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.layouts.IOneFlexibleChildLayout;
	import org.apache.flex.html.supportClasses.ICollapsible;
	
	public class EasyAccordionCollapseBead extends AccordionCollapseBead
	{
		private var _strand:IStrand;
		private var lastSelectedIndex:int = -1;
		public function EasyAccordionCollapseBead()
		{
			super();
		}
		
		private function findPreviousNonCollapsed():ICollapsible
		{
			var n:int = view.dataGroup.numElements;
			for (var i:int = 0; i < n; i++)
			{
				var collapsible:ICollapsible = view.dataGroup.getElementAt(i) as ICollapsible;
				if (collapsible.collapsedHeight != (collapsible as ILayoutChild).height)
				{
					return collapsible;
				}
			}
			return null;
		}
		
		private function get view():IListView
		{
			return host.view as IListView;			
		}
		
		override protected function selectedIndexChangedHandler(event:Event):void
		{
			var newChild:UIBase = view.dataGroup.getElementAt(host.selectedIndex) as UIBase;
			var oldChild:UIBase = findPreviousNonCollapsed() as UIBase;
			if (!newChild || !oldChild)
			{
				return;
			}
			var effect:Effect = getResize(newChild, oldChild);
			effect.addEventListener(Effect.EFFECT_END, effectEndHandler);
			layout.flexibleChild = newChild.id;
			effect.play();
		}
		
		private function get layout():IOneFlexibleChildLayout
		{
			return host.getBeadByType(IOneFlexibleChildLayout) as IOneFlexibleChildLayout;
		}
		
		protected function effectEndHandler(event:Event):void
		{
			(event.target as IEventDispatcher).removeEventListener(Effect.EFFECT_END, effectEndHandler);
			layout.layout();
		}
		
		private function getResize(newChild:UIBase, oldChild:UIBase):Effect
		{
			var resizeNew:Resize = new Resize(newChild);
			resizeNew.heightTo = oldChild.height;
			var resizeOld:Resize = new Resize(oldChild);
			resizeOld.heightTo = (oldChild as ICollapsible).collapsedHeight;
			var parallel:Parallel = new Parallel();
			parallel.children = [resizeNew, resizeOld];
			return parallel;
		}
	}
}