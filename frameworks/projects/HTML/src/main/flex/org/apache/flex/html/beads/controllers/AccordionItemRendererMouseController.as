package org.apache.flex.html.beads.controllers
{
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.ItemClickedEvent;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.html.supportClasses.AccordionItemRenderer;
	
	public class AccordionItemRendererMouseController implements IBeadController
	{
		private var _strand:IStrand;
		
		public function AccordionItemRendererMouseController()
		{
		}
		
		private function get accordionItemRenderer():AccordionItemRenderer
		{
			return _strand as AccordionItemRenderer;		
		}
		
		public function get strand():IStrand
		{
			return _strand;
		}

		public function set strand(value:IStrand):void
		{
			_strand = value;
			accordionItemRenderer.titleBar.addEventListener(MouseEvent.CLICK, titleBarClickHandler);
		}
		
		protected function titleBarClickHandler(event:MouseEvent):void
		{
			var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
			newEvent.data = accordionItemRenderer.data;
			newEvent.multipleSelection = event.shiftKey;
			newEvent.index = accordionItemRenderer.index;
			
			accordionItemRenderer.dispatchEvent(newEvent);
		}
	}
}