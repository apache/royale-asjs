package echarts
{

    import org.apache.royale.events.EventDispatcher;

    public class YAxis extends EventDispatcher{
		private var _type:String;

        [Bindable("yAxisChanged")]
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
            dispatchEvent(new Event("yAxisChanged"));
		}

        public function get obj():Object {
            return {type: this.type};
        }
    }
}