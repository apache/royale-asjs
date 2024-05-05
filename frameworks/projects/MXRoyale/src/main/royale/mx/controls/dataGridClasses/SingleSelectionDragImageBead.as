////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package mx.controls.dataGridClasses
{

	import mx.controls.listClasses.IListItemRenderer;
	import mx.controls.listClasses.ListBase;
	import mx.core.IUIComponent;
	import mx.managers.DragManager;
	import mx.managers.dragClasses.DragProxy;

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IDragInitiator;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.Lookalike;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.Button;
	import org.apache.royale.html.Group;
	import org.apache.royale.html.Label;
	import org.apache.royale.html.beads.DataContainerView;
	import org.apache.royale.html.beads.IDataGridView;
	import org.apache.royale.html.beads.SingleSelectionDragImageBead;
	import org.apache.royale.html.beads.controllers.DragMouseController;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.getParentOrSelfByType;

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}


	/**
	 *  The SingleSelectionDragImageBead produces a UIBase component that represents
	 *  the item being dragged. It does this by taking the data associcated with the
	 *  index of the item selected and running the toString() function on it, placing
	 *  it inside of a Label that is inside of Group (which is given the className of
	 *  "DragImage").
	 *
	 *  The createDragImage() function can be overridden and a different component returned.
	 *
	 *  @see org.apache.royale.html.beads.SingleSelectionDragSourceBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class SingleSelectionDragImageBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SingleSelectionDragImageBead()
		{
			super();
		}

		private var _strand:IStrand;
		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			(_strand as IEventDispatcher).addEventListener(DragEvent.DRAG_START, handleDragStart);
			(_strand as IEventDispatcher).addEventListener('showDragFeedback', showDragFeedback);
		}

		/**
		 * Creates an example/temporary component to be dragged and returns it.
		 *
		 * @param ir IItemRenderer The itemRenderer to be used as a template.
		 * @return UIBase The "dragImage" to use.
		 *
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		protected function createDragImage(ir:IItemRenderer):UIBase
		{
			var iir:IIndexedItemRenderer = ir as IIndexedItemRenderer;
			var dragProxy:DragProxy = new DragProxy(ir as IUIComponent, null/*dragSource*/);
			var w:uint=0;
			var h:uint=0
			if (iir) {
				var _lookAlike:UIBase;
				var index:uint = iir.index;
				var dataGridView:IDataGridView = (_strand as ListBase).view as IDataGridView;
				var colLists:Array = dataGridView.columnLists;
				for each(var list:DataGridColumnList in colLists) {
					var renderer:IListItemRenderer = (list.view as DataContainerView).getItemRendererForIndex(index) as IListItemRenderer;
					_lookAlike = createLookAlike(renderer);
					_lookAlike.x = w; //+xOffset;
					_lookAlike.y = 0; // +yOffset;
					w += _lookAlike.width;
					h = Math.max(h,_lookAlike.height);
					_lookAlike.alpha = 0.5;
					dragProxy.addElement(_lookAlike);
				}
			}

			dragProxy.setActualSize(w, h);
			dragProxy.allowMove = true;

			return dragProxy;

		}

		protected function showDragFeedback(event:ValueEvent):void{
			if (event.value) {
				showFeedback(event.value + '');
			}
		}

		public function showFeedback(feedback:String):void
		{
			// 	// trace("-->showFeedback for DragManagerImpl", sm, feedback);
			if (DragMouseController.dragImage )
			{
				var dragProxy:DragProxy = DragMouseController.dragImage as DragProxy;
				if (dragProxy) {
					if (feedback == DragManager.MOVE && !dragProxy.allowMove)
						feedback = DragManager.COPY;

					dragProxy.action = feedback;
					dragProxy.showFeedback();
				}
			}
		}

		private function createLookAlike(dragInitiator:IUIBase):UIBase
		{
			var dragImage:UIBase = new Lookalike(dragInitiator);
			dragImage.className = "DragImage";
			dragImage.width = dragInitiator.width;
			dragImage.height = dragInitiator.height;
			COMPILE::JS
			{
				dragImage.element.style.position = 'absolute';
				//dragImage.element.style.cursor = 'pointer';
				dragImage.element.style.pointerEvents = 'none';
			}
			return dragImage;
		}

		/*private function findIndexedItemRenderer(start:UIBase, listArea:DataGridListArea):IIndexedItemRenderer{
			var ret:IIndexedItemRenderer;
			var item:UIBase = start;
			if (!listArea.contains(item)) return null;
			while (!ret && item && item != listArea) {
				//we need the topmost itemRenderer type inside the columnlist (which is child of listArea)
				if (item is IIndexedItemRenderer && IChild(item.parent).parent == listArea) {
					ret = item as IIndexedItemRenderer;
				} else {
					item = item.parent as UIBase;
				}
			}
			return ret;
		}*/

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 */
		private function handleDragStart(event:DragEvent):void
		{
			//trace("SingleSelectionDragImageBead received the DragStart via: "+event.target.toString());

			var relatedObject:Object = event.relatedObject;
			var renderer:IItemRenderer = getParentOrSelfByType(relatedObject as IChild, IItemRenderer) as IItemRenderer;
			if (renderer) {
				DragMouseController.dragImage = createDragImage(renderer);
				showFeedback(DragManager.NONE)
			}
		}
	}
}
