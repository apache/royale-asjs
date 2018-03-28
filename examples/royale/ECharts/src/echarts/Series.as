package echarts
{
    import org.apache.royale.events.EventDispatcher;

    public class Series  extends EventDispatcher{
		private var _data:Array;
		private var _name:String;
		private var _type:String;

        [Bindable("seriesChanged")]
		public function get data():Array
		{
			return _data;
		}

		public function set data(value:Array):void
		{
			_data = value;
            dispatchEvent(new Event("seriesChanged"));
		}

		[Bindable("seriesChanged")]
		public function get name():String
		{
			return _name;
		}
        
		public function set name(value:String):void
		{
			_name = value;
			dispatchEvent(new Event("seriesChanged"));
		}

		[Bindable("seriesChanged")]
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
            dispatchEvent(new Event("seriesChanged"));
		}

        public function get obj():Object {
            return {data: this.data,
                    type: this.type,
                    name: this.name};
        }
    }
}