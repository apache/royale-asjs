package controllers
{
	import flash.events.Event;

	public class MyController
	{
		public function MyController(app:FlexJSTest)
		{
			this.app = app;
			app.addEventListener("viewChanged", viewChangeHandler);
		}
		
		private var app:FlexJSTest;
		
		private function viewChangeHandler(event:Event):void
		{
			app.initialView.addEventListener("buttonClicked", buttonClickHandler);
		}
		
		private function buttonClickHandler(event:Event):void
		{
			app.model.labelText = "Hello Universe";
		}
	}
}