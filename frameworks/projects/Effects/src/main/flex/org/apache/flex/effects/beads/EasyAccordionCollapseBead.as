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
package org.apache.flex.effects.beads
{
	
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.AccordionCollapseBead;
	import org.apache.flex.html.beads.IListView;
	import org.apache.flex.html.supportClasses.ICollapsible;
	import org.apache.flex.utils.AbsoluteLayoutTweener;
	
	public class EasyAccordionCollapseBead extends AccordionCollapseBead
	{
		public function EasyAccordionCollapseBead()
		{
			super();
		}
		
		private function findPreviousNonCollapsedIndex():int
		{
			var n:int = view.dataGroup.numElements;
			for (var i:int = 0; i < n; i++)
			{
				var collapsible:ICollapsible = view.dataGroup.getElementAt(i) as ICollapsible;
				if (collapsible.collapsedHeight != (collapsible as ILayoutChild).height)
				{
					return i;
				}
			}
			return -1;
		}
		
		private function get view():IListView
		{
			return host.view as IListView;			
		}
		
		override protected function selectedIndexChangedHandler(event:Event):void
		{
			var newChild:UIBase = view.dataGroup.getElementAt(host.selectedIndex) as UIBase;
			var oldChildIndex:int = findPreviousNonCollapsedIndex();
			var oldCollapsible:ICollapsible = view.dataGroup.getElementAt(oldChildIndex) as ICollapsible;
			if (!newChild || oldChildIndex < 0)
			{
				return;
			}
			var collapseHeight:Number = oldCollapsible.collapsedHeight;
			var tweener:AbsoluteLayoutTweener = new AbsoluteLayoutTweener(layout, host as ILayoutParent);
			tweener.setBaseline();
			var oldLayoutChild:ILayoutChild = tweener.mockLayoutParent.contentView.getElementAt(oldChildIndex) as ILayoutChild;
			oldLayoutChild.height = collapseHeight;
			layout.flexibleChild = newChild.id;
			layout.layout();
			tweener.play();
		}
				
	}
}
