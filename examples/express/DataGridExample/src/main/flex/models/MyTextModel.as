package models
{
	import org.apache.flex.html.beads.models.TextModel;
	
	public class MyTextModel extends TextModel
	{
		public function MyTextModel()
		{
			trace("This is my text model");
			super();
		}
		
		override public function set text(value:String):void
		{
			super.text = value;
		}
	}
}