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
package org.apache.flex.html.beads
{

	import org.apache.flex.collections.ArrayList;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.IDataProviderModel;
	import org.apache.flex.core.IDocument;
	import org.apache.flex.core.IDragInitiator;
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.IParent;
	import org.apache.flex.core.ISelectableItemRenderer;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.Lookalike;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.DragEvent;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.geom.Point;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.html.Button;
	import org.apache.flex.html.Group;
	import org.apache.flex.html.Label;
	import org.apache.flex.html.beads.controllers.DragMouseController;
	import org.apache.flex.utils.PointUtils;
	import org.apache.flex.utils.getParentOrSelfByType;

	COMPILE::JS
	{
		import org.apache.flex.core.WrappedHTMLElement;
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
	 *  @see org.apache.flex.html.beads.SingleSelectionDragSourceBead.
     *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class SingleSelectionDragImageBead extends EventDispatcher implements IBead
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function SingleSelectionDragImageBead()
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
		 * @param ir IItemRenderer The itemRenderer to be used as a template.
		 * @return UIBase The "dragImage" to use.
		 *
		 *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
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
		 *
		 */
		private function handleDragStart(event:DragEvent):void
		{
			trace("SingleSelectionDragImageBead received the DragStart via: "+event.target.toString());

			var renderer:IItemRenderer = getParentOrSelfByType(event.target as IChild, IItemRenderer) as IItemRenderer;
			if (renderer) {
				DragMouseController.dragImage = createDragImage(renderer);
			}
		}
	}
}
