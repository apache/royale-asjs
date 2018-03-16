package echarts
{

    public class XAxis{
			private var _data:Array = ["shirt","cardign","chiffon shirt","pants","heels","socks"];

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