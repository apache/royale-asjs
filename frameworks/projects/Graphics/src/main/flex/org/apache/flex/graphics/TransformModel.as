package org.apache.flex.graphics
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITransformModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.geom.Matrix;
	
	public class TransformModel extends EventDispatcher implements ITransformModel
	{
		private var _matrix:Matrix;
		
		public function TransformModel()
		{
		}
		
		public function get matrix():Matrix
		{
			return _matrix;
		}

		public function set matrix(value:Matrix):void
		{
			_matrix = value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set strand(value:IStrand):void {}

	}
}