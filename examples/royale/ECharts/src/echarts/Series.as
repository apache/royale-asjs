package echarts
{

    public class Series{
		private var _data:Array = [5, 20, 36, 10, 10, 20];
		private var _name:String;
		private var _type:String;

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		private function get name():String
		{
			return _name;
		}

		private function set name(value:String):void
		{
			_name = value;
		}

		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
		}
		
    }
}