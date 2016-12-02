package simple
{
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.IChild;

	/**
	 * GenericList relies on an itemRenderer factory to produce its children componenents
	 * and on a layout to arrange them. This is the only UI element aside from the itemRenderers.
	 */
	public class GenericList extends UIBase implements IItemRendererParent, ILayoutParent, ILayoutHost
	{
		public function GenericList()
		{
			super();
		}

		public function get dataProvider():Object
		{
			return ISelectionModel(model).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			ISelectionModel(model).dataProvider = value;
		}

		public function get labelField():String
		{
			return ISelectionModel(model).labelField;
		}
		public function set labelField(value:String):void
		{
			ISelectionModel(model).labelField = value;
		}

		public function getLayoutHost():ILayoutHost
		{
			return this;
		}

		public function get contentView():IParentIUIBase
		{
			return this;
		}

		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			var child:IItemRenderer = getElementAt(index) as IItemRenderer;
			return child;
		}

		public function removeAllElements():void
		{
			while (numElements > 0) {
				var child:IChild = getElementAt(0);
				removeElement(child);
			}
		}

		public function updateAllItemRenderers():void
		{
			//todo: IItemRenderer does not define update function but DataItemRenderer does
			//for(var i:int = 0; i < numElements; i++) {
			//	var child:IItemRenderer = getElementAt(i) as IItemRenderer;
			//	child.update();
			//}
		}
	}
}
