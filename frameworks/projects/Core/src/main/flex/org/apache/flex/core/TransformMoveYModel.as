package org.apache.flex.core
{
	import org.apache.flex.geom.MeagerMatrix;

	public class TransformMoveYModel extends TransformModel
	{
		private var _y:Number;
		
		public function TransformMoveYModel()
		{
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
			matrix = new MeagerMatrix(1, 0, 0, 1, 0, y);
		}

	}
}