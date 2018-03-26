package echarts
{
    import org.apache.royale.events.EventDispatcher;

    public class XAxis extends EventDispatcher{
		private var _data:Array;
        private var _position:String;

        [Bindable("xAxisChanged")]
		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
            dispatchEvent(new Event("xAxisChanged"));
		}

        [Bindable("xAxisChanged")]
		public function get position():String
		{
			return _position;
		}

		public function set position(value:String):void
		{
			_position = value;
            dispatchEvent(new Event("xAxisChanged"));
		}

        public function get obj():Object {
            return {data: this.data,
                    position: this.position};
        }
    }
}