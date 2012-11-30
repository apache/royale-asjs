package 
{
	import flash.events.Event;
	
	import org.apache.flex.core.ViewBase;
	import org.apache.flex.html.staticControls.TextButton;
	import org.apache.flex.html.staticControls.Label;
	import org.apache.flex.html.staticControls.beads.models.TextModel;
	
	public class MyInitialView extends ViewBase
	{
		public function MyInitialView()
		{
			super();
		}
		
		override public function get uiDescriptors():Array
		{
			return [
				Label,
				null,
				"lbl",
				2,
				"x", 100,
				"y", 25,
				0,
				0,
				1, 
				"text", 0, "model", "labelText", "labelTextChanged",
				TextButton,
				null,
				null,
				3,
				"text", "OK",
				"x", 100,
				"y", 75,
				0,
				1,
				"click", clickHandler,
				0
				];
		}
		
		public var lbl:Label;
		
		private function clickHandler(event:Event):void
		{
			dispatchEvent(new Event("buttonClicked"));
		}
	}
}