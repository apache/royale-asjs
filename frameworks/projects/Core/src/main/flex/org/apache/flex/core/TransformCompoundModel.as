package org.apache.flex.core
{
	import org.apache.flex.geom.Matrix;

	public class TransformCompoundModel extends TransformModel
	{
		private var _tranformModels:Array;

		[DefaultProperty("transformModels")]
		public function get tranformModels():Array
		{
			return _tranformModels;
		}

		public function set tranformModels(value:Array):void
		{
			_tranformModels = value;
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