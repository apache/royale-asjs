package org.apache.flex.html.beads
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.Accordion;
	import org.apache.flex.html.beads.layouts.IOneFlexibleChildLayout;
	import org.apache.flex.html.supportClasses.ICollapsible;
	
	public class AccordionCollapseBead implements IAccordionCollapseBead
	{
		private var _strand:IStrand;
		private var lastSelectedIndex:int = -1;
		public function AccordionCollapseBead()
		{
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			host.model.addEventListener("selectedIndexChanged", selectedIndexChangedHandler);
		}
		
		private function get host():Accordion
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
			var layout:IOneFlexibleChildLayout = host.getBeadByType(IOneFlexibleChildLayout) as IOneFlexibleChildLayout;
			if (lastSelectedIndex > -1)
			{
				var lastElement:ICollapsible = view.dataGroup.getItemRendererForIndex(lastSelectedIndex) as ICollapsible;
				lastElement.collapse();
			}
			lastSelectedIndex = host.selectedIndex;
			layout.flexibleChild = newChild.id;
			layout.layout();
		}
	}
}