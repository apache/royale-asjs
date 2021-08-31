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
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.DividedContainer;
	import org.apache.royale.html.beads.models.DividedContainerModel;
	import org.apache.royale.html.supportClasses.DividedContainerDivider;
	import org.apache.royale.html.supportClasses.IDividedContainerDivider;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 * The DividedContainerView class is responsible for generating the
	 * DividedContainerSeparators between the children and placing them
	 * in the z-order between the children.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DividedContainerView extends BeadViewBase
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DividedContainerView()
		{
		}


		/**
		 * @copy org.apache.royale.core.IStrand#strand
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand("childrenAdded", handleChildrenAdded);
			(_strand as UIBase).model.addEventListener("pairAdjustmentChanged", handlePairAdjustmentChanged);
		}

		/**
		 * Handles the "childrenAdded" event and generates the separators between them
		 * based on the direction of the box.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		protected function handleChildrenAdded(event:Event):void
		{
			var n:int = (host as UIBase).numElements;

			// add in n-1 separators and adjustments
			var seps:Array = [];
			var adjustments:Array = [];
			if (n > 1) {
				for(var i:int=0; i < (n-1); i++) {
					var sep:IDividedContainerDivider = ValuesManager.valuesImpl.newInstance(_strand, "iDividerFactory") as IDividedContainerDivider;
					(host as UIBase).addElement(sep);
					seps.push(sep);
					adjustments.push(0);

					sep.model = (_strand as UIBase).model;
					sep.pairIndex = i;
				}
			}

			((host as UIBase).model as DividedContainerModel).pairAdjustments = adjustments;
			sendStrandEvent(_strand,"layoutNeeded");
		}

		/**
		 * @private
		 */
		private function handlePairAdjustmentChanged(event:Event):void
		{
			sendStrandEvent(_strand,"layoutNeeded");
		}
	}
}
