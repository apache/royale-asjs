package echarts
{
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.events.CollectionEvent;

	[Bindable("chartOptionsChanged")]
    public class EChartsOptions extends EventDispatcher{
        private var _title:Title = new Title();
        private var _xAxis:XAxis;
        private var _yAxis:YAxis = new YAxis();
		private var _seriesList:SeriesList;

		public function EChartsOptions() {
			
		}

        [Bindable("chartOptionsChanged")]
		public function get title():Title
		{
			return _title;
		}

		public function set title(value:Title):void
		{
			_title = value;
            dispatchEvent(new Event("chartOptionsChanged"));
		}

        [Bindable("chartOptionsChanged")]
		public function get xAxis():XAxis
		{
			return _xAxis;
		}

		public function set xAxis(value:XAxis):void
		{
			_xAxis = value;
			this._xAxis.addEventListener("xAxisChanged", this.optionsChanged);
            dispatchEvent(new Event("chartOptionsChanged"));
		}
       
        [Bindable("chartOptionsChanged")]
		public function get yAxis():YAxis
		{
			return _yAxis;
		}

		public function set yAxis(value:YAxis):void
		{
			_yAxis = value;
            dispatchEvent(new Event("chartOptionsChanged"));
		}

        [Bindable("chartOptionsChanged")]
		public function get seriesList():SeriesList
		{
			return _seriesList;
		}

		public function set seriesList(value:SeriesList):void
		{
			_seriesList = value;
			_seriesList.addEventListener("seriesListChanged", this.optionsChanged);
            dispatchEvent(new Event("chartOptionsChanged"));
		}

        public function get options():Object {
            return {title: this.title,
                    xAxis: this.xAxis.obj,
                    yAxis: this.yAxis,
                    series: getSeriesValues()};
        }

        protected function getSeriesValues():Array {
            var a:Array =  this.seriesList.series.map(function(item:Series):Object {
                return item.obj;
            });
            return a;
        }
        
		protected function optionsChanged(event:Event):void {
			dispatchEvent(new Event("chartOptionsChanged"));
		}

    }
}