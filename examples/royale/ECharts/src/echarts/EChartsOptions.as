package echarts
{
    public class EChartsOptions{
        private var _title:Title;
        private var _xAxis:XAxis;
        private var _yAxis:YAxis = new YAxis();
		private var _series:Array = [];

		private function get series():Array
		{
			return _series;
		}

		private function set series(value:Array):void
		{
			_series = value;
		}

		private function get yAxis():YAxis
		{
			return _yAxis;
		}

		private function set yAxis(value:YAxis):void
		{
			_yAxis = value;
		}

		public function get xAxis():XAxis
		{
			return _xAxis;
		}

		public function set xAxis(value:XAxis):void
		{
			_xAxis = value;
		}

		private function get title():Title
		{
			return _title;
		}

		private function set title(value:Title):void
		{
			_title = value;
		}
    }
}