package simple
{
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.IDataProviderItemRendererMapper;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.html.beads.IListView;

	import org.apache.flex.events.Event;

	/**
	 * GenericListView makes sure the itemRendererFactory and the layout beads are installed.
	 */
	public class GenericListView extends BeadViewBase implements IListView
	{
		public function GenericListView()
		{
			super();
		}

		public function get dataGroup():IItemRendererParent
		{
			return _strand as IItemRendererParent;
		}

		protected var listModel:ISelectionModel;

		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			var mapper:IDataProviderItemRendererMapper = _strand.getBeadByType(IDataProviderItemRendererMapper) as IDataProviderItemRendererMapper;
			if (mapper == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(host, "iDataProviderItemRendererMapper");
				if (c) {
					mapper = new c() as IDataProviderItemRendererMapper;
					_strand.addBead(mapper);
				}
			}

			host.addEventListener("itemsCreated", itemsCreatedHandler);

			listModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

			performLayout(null);
		}

		/**
		 * @private
		 */
		protected function itemsCreatedHandler(event:Event):void
		{
			performLayout(event);
		}

		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			performLayout(event);
		}

		/**
		 * @private
		 */
		protected function performLayout(event:Event):void
		{
			var layout:IBeadLayout = _strand.getBeadByType(IBeadLayout) as IBeadLayout;
			if (layout == null) {
				var c:Class = ValuesManager.valuesImpl.getValue(host, "iBeadLayout");
				if (c) {
					layout = new c() as IBeadLayout;
					_strand.addBead(layout);
				}
			}

			if (layout) {
				layout.layout();
			}
		}
	}
}
