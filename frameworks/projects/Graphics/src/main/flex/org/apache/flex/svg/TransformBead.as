package org.apache.flex.svg
{
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITransformModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.geom.Matrix;
	import org.apache.flex.graphics.IBeadTransform;
	import org.apache.flex.graphics.ITransformHost;

	COMPILE::SWF {
		import flash.display.Sprite;
		import flash.geom.Matrix;
	}
	
	
	public class TransformBead implements IBeadTransform
	{
		private var _strand:IStrand;
		private var transformModel:ITransformModel;
		
		public function TransformBead()
		{
		}
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */		
		public function set strand(value:IStrand):void
		{
			if (!(value is GraphicContainer))
			{
				throw new Error("This bead only works with svg GraphicContainers");
				return;
			}
			_strand = value;
			transformModel = value.getBeadByType(ITransformModel) as ITransformModel;
			if (!transformModel)
			{
				throw new Error("An ITransformModel needs to be defined.");
				return;
			}
			transformModel.addEventListener(Event.CHANGE, changeHandler);
			if (transformModel.matrix)
			{
				transform();
			}
		}
		
		COMPILE::SWF
		public function transform():void
		{
			var element:Sprite = host.transformElement as Sprite;
			var fjsm:org.apache.flex.geom.Matrix = transformModel.matrix;
			var flashMatrix:flash.geom.Matrix = new flash.geom.Matrix(fjsm.a, fjsm.b, fjsm.c, fjsm.d, fjsm.tx, fjsm.ty);
			element.transform.matrix = flashMatrix;
		}
		/**
		 * @flexjsignorecoercion HTMLElement
		 */
		COMPILE::JS
		public function transform():void
		{
			var element:org.apache.flex.core.WrappedHTMLElement = host.transformElement;
			(element.parentNode as HTMLElement).setAttribute("overflow", "visible");
			var fjsm:org.apache.flex.geom.Matrix = transformModel.matrix;
			var matrixArray:Array = [fjsm.a , fjsm.b, fjsm.c, fjsm.d, fjsm.tx, fjsm.ty];
			element.setAttribute("transform", "matrix(" +matrixArray.join(",") + ")";
		}
		
		private function changeHandler(e:Event):void
		{
			transform();
		}
		
		/**
		 *  The host component. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get host():ITransformHost
		{
			return _strand as ITransformHost;
		}
	}
}