package echarts
{
    import org.apache.royale.events.EventDispatcher;

    public class DataZoom  extends EventDispatcher{
		private var _id:String;
		private var _xAxisIndex:Array;
		private var _yAxisIndex:Array;
		private var _type:String;
		private var _filterMode:String;

        [Bindable("dataZoomChanged")]
		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
            dispatchEvent(new Event("dataZoomChanged"));
		}

		[Bindable("dataZoomChanged")]
		public function get xAxisIndex():Array
		{
			return _xAxisIndex;
		}
        
		public function set xAxisIndex(value:Array):void
		{
			_xAxisIndex = value;
			dispatchEvent(new Event("dataZoomChanged"));
		}

		[Bindable("dataZoomChanged")]
		public function get yAxisIndex():Array
		{
			return _yAxisIndex;
		}
        
		public function set yAxisIndex(value:Array):void
		{
			_yAxisIndex = value;
			dispatchEvent(new Event("dataZoomChanged"));
		}

		[Bindable("dataZoomChanged")]
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
            dispatchEvent(new Event("dataZoomChanged"));
		}

		[Bindable("dataZoomChanged")]
		public function get filterMode():String
		{
			return _filterMode;
		}

		public function set filterMode(value:String):void
		{
			_filterMode = value;
			dispatchEvent(new Event("dataZoomChanged"));
		}

        public function get obj():Object {
            return {id: this.id,
					xAxisIndex: this.xAxisIndex,
					yAxisIndex: this.yAxisIndex,
                    type: this.type,
                    filterMode: this.filterMode};
        }
    }
}