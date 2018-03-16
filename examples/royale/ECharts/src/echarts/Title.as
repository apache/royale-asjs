package echarts
{

    public class Title{
        private var _text:String;
        private var _show:Boolean;
        private var _link:String;
        private var _target:String;

		private function get text():String
		{
			return _text;
		}

		private function set text(value:String):void
		{
			_text = value;
		}

		private function get show():Boolean
		{
			return _show;
		}

		private function set show(value:Boolean):void
		{
			_show = value;
		}

		private function get link():String
		{
			return _link;
		}

		private function set link(value:String):void
		{
			_link = value;
		}

		private function get target():String
		{
			return _target;
		}

		private function set target(value:String):void
		{
			_target = value;
		}
    }
}