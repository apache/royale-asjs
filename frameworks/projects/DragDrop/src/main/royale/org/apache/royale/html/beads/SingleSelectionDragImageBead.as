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

	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.IDragInitiator;
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
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.Button;
	import org.apache.royale.html.Group;
	import org.apache.royale.html.Label;
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
			var dragImage:UIBase = new Lookalike(ir);
			dragImage.className = "DragImage";
			dragImage.width = (ir as IUIBase).width;
			dragImage.height = (ir as IUIBase).height;
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
			//trace("SingleSelectionDragImageBead received the DragStart via: "+event.target.toString());

			var relatedObject:Object = event.relatedObject;
			var renderer:IItemRenderer = getParentOrSelfByType(relatedObject as IChild, IItemRenderer) as IItemRenderer;
			if (renderer) {
				DragMouseController.dragImage = createDragImage(renderer);
			}
		}
	}
}
