package org.apache.flex.html.beads
{
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.layouts.IOneFlexibleChildLayout;

	public class AccordionView extends ListView
	{
		private var _layout:IOneFlexibleChildLayout;
		public function AccordionView()
		{
			super();
		}
		
		override protected function selectionChangeHandler(event:Event):void
		{
			super.selectionChangeHandler(event);
			var renderer:UIBase = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as UIBase;
			layout.flexibleChild = renderer.id;
		}
		
		public function get layout():IOneFlexibleChildLayout
		{
			if (!_layout)
			{
				_layout = _strand.getBeadByType(IOneFlexibleChildLayout) as IOneFlexibleChildLayout;
				if (!_layout) {
					var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
					if (c) {
						_layout = new c() as IOneFlexibleChildLayout;
						_strand.addBead(_layout);
					}
				}
			}
			return _layout;
		}
		
		override protected function performLayout(event:Event):void
		{
			if (layout && layout.flexibleChild)
			{
				super.performLayout(event);
			}
		}
	}
}