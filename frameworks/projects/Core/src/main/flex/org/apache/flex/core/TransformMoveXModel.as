package org.apache.flex.core
{
	import org.apache.flex.geom.MeagerMatrix;

	public class TransformMoveXModel extends TransformModel
	{
		private var _x:Number;
		
		public function TransformMoveXModel()
		{
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
			matrix = new MeagerMatrix(1, 0, 0, 1, x, 0);
		}

	}
}