package org.apache.flex.core
{
	import org.apache.flex.geom.MeagerMatrix;
	
	
	public class TransformRotateModel extends TransformModel
	{
		private var _angle:Number;
		
		public function TransformRotateModel()
		{
		}
		
		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
			var radians:Number = value * Math.PI/180;
			matrix = new MeagerMatrix(Math.cos(radians), Math.sin(radians), -Math.sin(radians), Math.cos(radians));
		}


	}
}