package org.apache.flex.core
{
	import org.apache.flex.geom.Matrix;

	[DefaultProperty("transformModels")]
	public class TransformCompoundModel extends TransformModel
	{
		private var _transformModels:Array;

		public function get transformModels():Array
		{
			return _transformModels;
		}

		public function set transformModels(value:Array):void
		{
			_transformModels = value;
			if (value && value.length > 0)
			{
				var length:int = value.length;
				var product:Matrix = (value[0] as ITransformModel).matrix.clone();
				for (var i:int = 1; i < length; i++)
				{
					var current:Matrix = (value[i] as ITransformModel).matrix;
					product.concat(current);
				}
				matrix = product;
			} else
			{
				matrix = new Matrix();
			}
		}

	}
}