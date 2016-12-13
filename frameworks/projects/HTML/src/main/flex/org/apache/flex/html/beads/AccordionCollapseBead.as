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
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.Accordion;
	import org.apache.flex.html.beads.layouts.IOneFlexibleChildLayout;
	import org.apache.flex.html.supportClasses.ICollapsible;
	import org.apache.flex.utils.StrandUtils;
	
	public class AccordionCollapseBead implements IAccordionCollapseBead
	{
		private var _strand:IStrand;
		private var lastSelectedIndex:int = -1;
		private var _layout:IOneFlexibleChildLayout;
		public function AccordionCollapseBead()
		{
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			host.model.addEventListener("selectedIndexChanged", selectedIndexChangedHandler);
			var idx:int = host.selectedIndex;
			if(idx < 0)
				idx = 0;

			var dg:IItemRendererParent = IListView(host.view).dataGroup as IItemRendererParent;
			var numElems:int = dg.numElements;
			for(var i:int = 0; i < numElems; i++){
				if(i == idx)
					continue;

				var elem:ICollapsible = dg.getItemRendererForIndex(i) as ICollapsible;
				elem.collapse();
			}
		}
		
		protected function get host():Accordion
		{
			return _strand as Accordion;
		}
		
		protected function selectedIndexChangedHandler(event:Event):void
		{
			var view:IListView = host.view as IListView;
			var newChild:UIBase = view.dataGroup.getElementAt(host.selectedIndex) as UIBase;
			if (!newChild)
			{
				return;
			}
			if (lastSelectedIndex > -1)
			{
				var lastElement:ICollapsible = view.dataGroup.getItemRendererForIndex(lastSelectedIndex) as ICollapsible;
				lastElement.collapse();
			}
			lastSelectedIndex = host.selectedIndex;
			layout.flexibleChild = newChild.id;
			layout.layout();
		}
		
		protected function get layout():IOneFlexibleChildLayout
		{
			if (!_layout)
			{
				_layout = StrandUtils.loadBead(IOneFlexibleChildLayout, "iBeadLayout", _strand) as IOneFlexibleChildLayout;
			}
			return _layout;
		}

	}
}