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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ITitleBarModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.Panel;
	import org.apache.royale.html.TitleBar;
	import org.apache.royale.html.beads.PanelView;
	
	public class AccordionItemRenderer extends Panel implements ISelectableItemRenderer, ICollapsible
	{
		private var _index:int;
		private var _selected:Boolean;
		private var _hovered:Boolean;
		private var _down:Boolean;
		private var value:Object;
		
		public function AccordionItemRenderer()
		{
			super();
			percentWidth = 100;
		}

		private var _selectable:Boolean = true;
		/**
         *  <code>true</code> if the item renderer is can be selected
         *  false otherwise. Use to configure a renderer to be non 
         *  selectable.
         *  
         *  Defaults to true
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;	
		}

		private var _hoverable:Boolean = true;
		/**
         *  <code>true</code> if the item renderer is can be hovered
         *  false otherwise. Use to configure a renderer to be non 
         *  hoverable.
         *  
         *  Defaults to true
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get hoverable():Boolean
		{
			return _hoverable;
		}

		public function set hoverable(value:Boolean):void
		{
			_hoverable = value;	
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
			id = "item" + index;
		}

		public function get labelField():String
		{
			return null;
		}
		
		public function set labelField(value:String):void
		{
		}
				
		public function get hovered():Boolean
		{
			return _hovered;
		}
		
		public function set hovered(value:Boolean):void
		{
			_hovered = value;
		}
		
		public function get down():Boolean
		{
			return _down;
		}
		
		public function set down(value:Boolean):void
		{
			_down = value;
		}
		
		public function get data():Object
		{
			return numElements > 0 ? getElementAt(0) : null;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		public function set data(value:Object):void
		{
			while (numElements > 0)
			{
				removeElement(getElementAt(0));
			}
			addElement(value as IChild);
			var dataAsStrand:IStrand = value as IStrand;
			if (dataAsStrand)
			{
				var dataTitleModel:ITitleBarModel = dataAsStrand.getBeadByType(ITitleBarModel) as ITitleBarModel;
				if (dataTitleModel)
				{
//					titleBar.model = dataTitleModel;
					titleBar.title = dataTitleModel.title; // temp fix. The line above should be swapoped with this one once databinding works.
				}
			}
			dispatchEvent(new Event("dataChange"));
		}
		
		public function get listData():Object
		{
			return null;
		}
		
		public function set listData(value:Object):void
		{
		}
		
		public function get itemRendererOwnerView():Object
		{
			return null;
		}
		
		public function set itemRendererOwnerView(value:Object):void
		{
		}
		
		public function get titleBar():TitleBar
		{
			return (getBeadByType(PanelView) as PanelView).titleBar as TitleBar;
		}
		
		public function get collapsedHeight():Number
		{
			return titleBar ? titleBar.height : NaN;
		}
		
		public function get collapsedWidth():Number
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
		public function collapse():void
		{
			height = collapsedHeight;
		}
		
		public function get collapsed():Boolean
		{
			return height == collapsedHeight;
		}
		
	}
}
