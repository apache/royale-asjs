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
package org.apache.flex.mdl
{
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.ILayoutHost;
	import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.IChild;

	/**
	 * GenericList relies on an itemRenderer factory to produce its children componenents
	 * and on a layout to arrange them. This is the only UI element aside from the itemRenderers.
	 */
	public class List extends UIBase implements IItemRendererParent, ILayoutParent, ILayoutHost
	{
		public function List()
		{
			super();
		}

		public function get dataProvider():Object
		{
			return ISelectionModel(model).dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			ISelectionModel(model).dataProvider = value;
		}

		public function get labelField():String
		{
			return ISelectionModel(model).labelField;
		}
		public function set labelField(value:String):void
		{
			ISelectionModel(model).labelField = value;
		}

		public function getLayoutHost():ILayoutHost
		{
			return this;
		}

		public function get contentView():IParentIUIBase
		{
			return this;
		}

		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			var child:IItemRenderer = getElementAt(index) as IItemRenderer;
			return child;
		}

		public function removeAllElements():void
		{
			while (numElements > 0) {
				var child:IChild = getElementAt(0);
				removeElement(child);
			}
		}

		public function updateAllItemRenderers():void
		{
			//todo: IItemRenderer does not define update function but DataItemRenderer does
			//for(var i:int = 0; i < numElements; i++) {
			//	var child:IItemRenderer = getElementAt(i) as IItemRenderer;
			//	child.update();
			//}
		}
	}
}
