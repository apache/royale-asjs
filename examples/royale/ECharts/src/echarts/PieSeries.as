package echarts
{

    public class PieSeries extends Series{
		private var _clockwise:Boolean;
		private var _startAngle:Number;
		private var _minAngle:Number;
		private var _roseType:String;
		private var _radius:Array;
		private var _center:Array;

        [Bindable("seriesChanged")]
		public function get clockwise():Boolean
		{
			return _clockwise;
		}

		public function set clockwise(value:Boolean):void
		{
			_clockwise = value;
            dispatchEvent(new Event("seriesChanged"));
		}

		[Bindable("seriesChanged")]
		public function get startAngle():Number
		{
			return _startAngle;
		}
        
		public function set startAngle(value:Number):void
		{
			_startAngle = value;
			dispatchEvent(new Event("seriesChanged"));
		}

		[Bindable("seriesChanged")]
		public function get minAngle():Number
		{
			return _minAngle;
		}
        
		public function set minAngle(value:Number):void
		{
			_minAngle = value;
			dispatchEvent(new Event("seriesChanged"));
		}

		[Bindable("seriesChanged")]
		public function get roseType():String
		{
			return _roseType;
		}

		public function set roseType(value:String):void
		{
			_roseType = value;
            dispatchEvent(new Event("seriesChanged"));
		}

		[Bindable("seriesChanged")]
		public function get radius():Array
		{
			return _radius;
		}

		public function set radius(value:Array):void
		{
			_radius = value;
            dispatchEvent(new Event("seriesChanged"));
		}

		[Bindable("seriesChanged")]
		public function get center():Array
		{
			return _center;
		}

		public function set center(value:Array):void
		{
			_center = value;
            dispatchEvent(new Event("seriesChanged"));
		}

        override public function get obj():Object {
			//Combine attributes from superclass with this class's attributes
			var obj:Object = super.obj;
            var thisObj:Object = {
				clockwise: this.clockwise,
                startAngle: this.startAngle,
                minAngle: this.minAngle,
				roseType:this.roseType,
				radius:this.radius,
				center:this.center
			};
			for (var attrname:String in thisObj) 
			{ 
				obj[attrname] = thisObj[attrname]; 
			}
			return obj;
        }
    }
}