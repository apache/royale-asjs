
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
package mx.controls.beads
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueEvent;
	import mx.core.IDataRenderer;
	import org.apache.royale.core.IStrandWithModel;

	/**
	 *  The XMLTreeSingleSelectionDragSourceBead handles drag source operaions special to XML data
	 *
	 *  @see org.apache.royale.html.beads.SingleSelectionDropTargetBead.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	public class XMLTreeSingleSelectionDragSourceBead implements IBead
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function XMLTreeSingleSelectionDragSourceBead()
		{
			super();
		}

		private var _strand:IStrand;
		private var _draggedXML:XML;

		/**
		 * @private
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			(value as IEventDispatcher).addEventListener("dragSourceSet", dragSourceSetHandler);
			(value as IEventDispatcher).addEventListener("acceptingMoveDrop", acceptingMoveDropHandler);
			(value.getBeadByType(TreeSingleSelectionDragSourceBead) as IEventDispatcher).addEventListener("complete", completeHandler)
		}

		/**
		 * @private
		 */
		private function dragSourceSetHandler(event:ValueEvent):void
		{
			_draggedXML = (event.value as IDataRenderer).data as XML;
		}

		/**
		 * @private
		 */
		private function acceptingMoveDropHandler(event:Event):void
		{
			var parent:XML = _draggedXML.parent() as XML;
			if (parent)
			{
				parent.removeChild(_draggedXML);
				((_strand as IStrandWithModel).model as IEventDispatcher).dispatchEvent(new Event("dataProviderChanged"));
			}
		}

		/**
		 * @private
		 */
		private function completeHandler(event:Event):void
		{
			_draggedXML = null;
		}

	}
}
