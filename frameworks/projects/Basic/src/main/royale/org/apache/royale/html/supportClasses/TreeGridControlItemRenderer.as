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
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.html.TextButton;
	import org.apache.royale.html.supportClasses.UIItemRendererBase;

	public class TreeGridControlItemRenderer extends UIItemRendererBase implements IItemRendererOwnerView
	{
		public function TreeGridControlItemRenderer()
		{
			super();
			
			_controlButton = new TextButton();
		}
		
        private var _listData:Object;
        
        [Bindable("__NoChangeEvent__")]
        /**
         *  Additional data about the list structure the itemRenderer may
         *  find useful.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get listData():Object
        {
            return _listData;
        }
        public function set listData(value:Object):void
        {
            _listData = value;
        }
        
		private var _controlButton: TextButton;
		public function get controlButton():TextButton
		{
			return _controlButton;
		}
		
		private var _originalItemRenderer: IItemRendererClassFactory;
		
		public function get originalItemRenderer(): IItemRendererClassFactory
		{
			return _originalItemRenderer;
		}
		public function set originalItemRenderer(value: IItemRendererClassFactory):void
		{
			_originalItemRenderer = value;
			
			child = value.createItemRenderer() as UIBase;
			(child as IItemRenderer).data = this.data;
			this.addElement(child);
		}
		
		private var child:UIBase;
		
		override public function adjustSize():void
		{
			var treeData:TreeListData = listData as TreeListData;
			var controlLabel:String = treeData.hasChildren ? (treeData.isOpen ? "▼" : "▶") : " ";
			_controlButton.text = controlLabel;
			
			_controlButton.x = 0;
			_controlButton.y = 0;
			_controlButton.setWidthAndHeight(20, this.height);
			
			child.x = _controlButton.width;
			child.y = 0;
			child.setWidthAndHeight(this.width - _controlButton.width, this.height);			
		}
		
		// IItemRendererOwnerView implementation
		
        public function get numItemRenderers():int
        {
            return 1;
        }
        
		public function addItemRenderer(renderer:IItemRenderer, dispatchAdded:Boolean):void
		{
			this.addElement(renderer, dispatchAdded);
		}

		public function addItemRendererAt(renderer:IItemRenderer, index:int):void
		{
			this.addElementAt(renderer, index);
		}
		
		public function removeItemRenderer(renderer:IItemRenderer):void
		{
			this.removeElement(renderer);
		}
		
		public function getItemRendererForIndex(index:int):IItemRenderer
		{
			return child as IItemRenderer;
		}
		
        public function getItemRendererAt(index:int):IItemRenderer
        {
            return child as IItemRenderer;
        }
        
		public function removeAllItemRenderers():void
		{
			this.removeElement(child);
		}
		
        public function get host():IUIBase
        {
            return this;
        }
        
		public function updateAllItemRenderers():void
		{
		}
	}
}