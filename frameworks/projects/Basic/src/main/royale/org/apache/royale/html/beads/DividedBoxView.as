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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.DividedBox;
	import org.apache.royale.html.beads.models.DividedBoxModel;
	import org.apache.royale.html.supportClasses.DividedBoxDivider;
	import org.apache.royale.html.supportClasses.HDividedBoxDivider;
	import org.apache.royale.html.supportClasses.VDividedBoxDivider;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	/**
	 * The DividedBoxView class is responsible for generating the
	 * DividedBoxSeparators between the children and placing them
	 * in the z-order between the children.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class DividedBoxView implements IBeadView
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function DividedBoxView()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 * @copy org.apache.royale.core.IStrand#strand
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			(_strand as IEventDispatcher).addEventListener("childrenAdded", handleChildrenAdded);
			(_strand as UIBase).model.addEventListener("pairAdjustmentChanged", handlePairAdjustmentChanged);
		}
		
		/**
		 * @private
		 */
		public function get host():IUIBase
		{
			return _strand as IUIBase;
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
					var sep:DividedBoxDivider;
					if (((_strand as UIBase).model as DividedBoxModel).direction == "horizontal") {
						sep = new HDividedBoxDivider();
					} else {
						sep = new VDividedBoxDivider();
					}
					(host as UIBase).addElement(sep);
					seps.push(sep);
					adjustments.push(0);
					
					sep.model = (_strand as UIBase).model;
					sep.pairIndex = i;
				}
			}
			
			((host as UIBase).model as DividedBoxModel).pairAdjustments = adjustments;
						
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 */
		private function handlePairAdjustmentChanged(event:Event):void
		{
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
	}
}