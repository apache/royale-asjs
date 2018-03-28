package echarts
{
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.collections.ArrayList;
    import org.apache.royale.events.CollectionEvent;

	[Bindable("chartOptionsChanged")]
    public class EChartsOptions extends EventDispatcher{
        private var _title:Title = new Title();
        private var _xAxis:XAxis;
        private var _yAxis:YAxis;
		private var _seriesList:SeriesList;
		private var _dataZoomList:DataZoomList;

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
			this._xAxis.addEventListener("yAxisChanged", this.optionsChanged);
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

		[Bindable("chartOptionsChanged")]
		public function get dataZoomList():DataZoomList
		{
			return _dataZoomList;
		}

		public function set dataZoomList(value:DataZoomList):void
		{
			_dataZoomList = value;
			_dataZoomList.addEventListener("dataZoomListChanged", this.optionsChanged);
            dispatchEvent(new Event("chartOptionsChanged"));
		}

        public function get options():Object {
            return {title: this.title,
                    xAxis: this.getXAxisObj(),
                    yAxis: this.getYAxisObj(),
                    series: getSeriesValues(),
					dataZoom: getDataZoomValues()};
        }

		protected function getXAxisObj():Object {
			if(this.xAxis) {
				return this.xAxis.obj;
			}
			return {};
		}

		protected function getYAxisObj():Object {
			if(this.yAxis) {
				return this.yAxis.obj;
			}
			return {};
		}

        protected function getSeriesValues():Array {
			if(this.seriesList) {
				return this.seriesList.series.map(function(item:Series):Object {
					return item.obj;
				});
			}
            return [];
        }

		protected function getDataZoomValues():Array {
			if(this.dataZoomList) {
				return this.dataZoomList.dataZoom.map(function(item:DataZoom):Object {
					return item.obj;
				});
			}
            return [];
        }
        
		protected function optionsChanged(event:Event):void {
			dispatchEvent(new Event("chartOptionsChanged"));
		}

    }
}