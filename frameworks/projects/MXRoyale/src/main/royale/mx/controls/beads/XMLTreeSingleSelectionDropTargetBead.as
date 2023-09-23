
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
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.html.util.getModelByType;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.events.DragEvent;

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
	public class XMLTreeSingleSelectionDropTargetBead implements IBead
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function XMLTreeSingleSelectionDropTargetBead()
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
			(value as IEventDispatcher).addEventListener("handlingDragDrop", handlingDragDropHandler);
		}

		/**
		 * @private
		 */
		private function handlingDragDropHandler(event:ValueEvent):void
		{
			var dataProviderModel:IDataProviderModel = getModelByType(_strand,IDataProviderModel) as IDataProviderModel;
			if (event.value)
			{
				var targetXML:XML = (event.value as IItemRenderer).data as XML;
				if (targetXML)
				{
					var parent:XML = targetXML.parent() as XML;
					if (parent && DragEvent.dragSource is XML)
					{
						parent.insertChildBefore(targetXML, DragEvent.dragSource as XML);
					}
				}
			}
		}

	}
}
