package org.apache.flex.core
{
	import org.apache.flex.geom.MeagerMatrix;

	public class TransformScaleModel extends TransformModel
	{
		private var _scale:Number
		public function TransformScaleModel()
		{
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
			matrix = new MeagerMatrix(scale, 0, 0, scale, 0, 0);
		}

	}
}