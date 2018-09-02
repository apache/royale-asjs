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
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.IDocument;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.layouts.IOneFlexibleChildLayout;
	import org.apache.royale.html.supportClasses.ICollapsible;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	/**
	 * The AccordionView sets up the components for the Accordion component.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class AccordionView extends ListView
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function AccordionView()
		{
			super();
		}
		
		private var _layout:IOneFlexibleChildLayout;
		private function get elements():Array
		{
			var host:UIBase = _strand as UIBase;
			var e:Array = [];
			for (var i:int = 0; i < host.numElements; i++) {
				e.push(host.getElementAt(i));
			}
			return e;
		}
		
		/**
		 * @private
		 */
		override protected function selectionChangeHandler(event:Event):void
		{
			super.selectionChangeHandler(event);
			var model:ISelectionModel = loadBeadFromValuesManager(ISelectionModel, "iBeadModel", host) as ISelectionModel;
			layout.flexibleChild = String(model.selectedIndex);
		}
		
		/**
		 * @private
		 */
		public function get layout():IOneFlexibleChildLayout
		{
			if (!_layout)
			{
				_layout = loadBeadFromValuesManager(IOneFlexibleChildLayout, "iBeadLayout", _strand) as IOneFlexibleChildLayout;
				if (_layout)
					IDocument(_layout).setDocument(elements);
				
			}
			return _layout;
		}
		
		COMPILE::SWF
		/**
		 * @private
		 */
		override protected function itemsCreatedHandler(event:Event):void
		{
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = 0; i < n; i++)
			{
				var child:ICollapsible = dataGroup.getItemRendererForIndex(i) as ICollapsible;
				child.collapse();
			}
			super.itemsCreatedHandler(event);
		}
	}
}
