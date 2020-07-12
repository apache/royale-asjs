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
package org.apache.royale.html.beads
{

	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IMultiSelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.Lookalike;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.DragEvent;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.Container;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.html.beads.controllers.DragMouseController;
	import org.apache.royale.html.beads.layouts.HorizontalLayout;
	import org.apache.royale.html.beads.layouts.VerticalLayout;
	import org.apache.royale.utils.getParentOrSelfByType;

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}


	/**
	 *  The MultiSelectionDragImageBead produces a UIBase component that represents
	 *  the item being dragged. It does this by creating lookalikes to all selected items
	 *  and adding them to a container.
	 *
	 *  The createDragImage() function can be overridden and a different component returned.
	 *
	 *  @see org.apache.royale.html.beads.SingleSelectionDragSourceBead.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class MultiSelectionDragImageBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function MultiSelectionDragImageBead()
		{
			super();
		}

		private var _strand:IStrand;

		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			IEventDispatcher(_strand).addEventListener(DragEvent.DRAG_START, handleDragStart);
		}

		/**
		 * Creates an example/temporary component to be dragged and returns it.
		 *
		 * @return UIBase The "dragImage" to use.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 *  @royaleignorecoercion org.apache.royale.core.IItemRendererOwnerView
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		protected function createDragImage():UIBase
		{
			var dragImage:Container = new Container();
			var layoutBead:IBead = _strand.getBeadByType(IBeadLayout);
			if (layoutBead is VerticalLayout)
			{
				dragImage.addBead(new VerticalLayout())
			} else
			{
				dragImage.addBead(new HorizontalLayout())
			}
			var itemRendererOwnerView:IItemRendererOwnerView = (_strand.getBeadByType(IBeadView) as IListView).dataGroup as IItemRendererOwnerView;
			var selectedIndices:Array = model.selectedIndices;
			for (var i:int = 0; i < selectedIndices.length; i++)
			{
				var ir:IItemRenderer = itemRendererOwnerView.getItemRendererForIndex(selectedIndices[i]);
				var lookalike:UIBase = new Lookalike(ir);
				lookalike.width = (ir as IUIBase).width;
				lookalike.height = (ir as IUIBase).height;
				dragImage.addElement(lookalike);
			}

			dragImage.className = "DragImage";
			COMPILE::JS 
			{
				dragImage.element.style.position = 'absolute';
				dragImage.element.style.cursor = 'pointer';
			}
			return dragImage;
		}

		/**
		 * @private
		 *  @royaleignorecoercion org.apache.royale.core.IChild
		 *  @royaleignorecoercion org.apache.royale.core.IItemRenderer
		 */
		private function handleDragStart(event:DragEvent):void
		{
			var relatedObject:Object = event.relatedObject;
			var itemRenderer:IItemRenderer = getParentOrSelfByType(relatedObject as IChild, IItemRenderer) as IItemRenderer;
			if (itemRenderer && !model.selectedItems)
			{
				model.selectedItems = [itemRenderer.data];
			}
			if (model.selectedItems && (itemRenderer && model.selectedItems.indexOf(itemRenderer.data) > -1))
			{
				DragMouseController.dragImage = createDragImage();
			}
		}

		/**
		 *  @royaleignorecoercion org.apache.royale.core.IMultiSelectionModel
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModel
		 */
		private function get model():IMultiSelectionModel
		{
			return (_strand as IStrandWithModel).model as IMultiSelectionModel;
		}
	}
}
