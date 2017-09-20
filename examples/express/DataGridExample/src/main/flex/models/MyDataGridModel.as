package models
{
	import org.apache.flex.html.beads.models.DataGridModel;
	
	public class MyDataGridModel extends DataGridModel
	{
		public function MyDataGridModel()
		{
			super();
			trace("This is my DataGrid model");
		}
		
		override public function set columns(value:Array):void
		{
			super.columns = value;
		}
	}
}