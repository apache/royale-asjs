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
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.MXMLDataInterpreter;
	
    [DefaultProperty("mxmlContent")]

    /**
	 *  The UIItemRendererBase class is the base class for all itemRenderers. An itemRenderer is used to
	 *  display a single datum within a collection of data. Components such as a List use itemRenderers to 
	 *  show their dataProviders.
	 *
 	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class UIItemRendererBase extends UIBase implements ISelectableItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function UIItemRendererBase()
		{
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
            MXMLDataInterpreter.generateMXMLProperties(this, mxmlProperties);
            MXMLDataInterpreter.generateMXMLInstances(this, this, MXMLDescriptor);
            
			super.addedToParent();
			
            // very common for item renderers to be resized by their containers,
            addEventListener("widthChanged", sizeChangeHandler);
            addEventListener("heightChanged", sizeChangeHandler);
			addEventListener("sizeChanged", sizeChangeHandler);

            // each MXML file can also have styles in fx:Style block
            ValuesManager.valuesImpl.init(this);
            
            dispatchEvent(new Event("initBindings"));
            dispatchEvent(new Event("initComplete"));
            
		}
		
		private var _itemRendererOwnerView:Object;
		
		/**
		 * The parent container for the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get itemRendererOwnerView():Object
		{
			return _itemRendererOwnerView;
		}
		public function set itemRendererOwnerView(value:Object):void
		{
			_itemRendererOwnerView = value;
		}
		
        /**
         *  @copy org.apache.royale.core.ItemRendererClassFactory#mxmlContent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var mxmlContent:Array;
        
		/**
		 * @private
		 */
        public function get MXMLDescriptor():Array
        {
            return null;
        }
        
        private var mxmlProperties:Array ;
        
		/**
		 * @private
		 */
        public function generateMXMLAttributes(data:Array):void
        {
            mxmlProperties = data;
        }
        
        private var _backgroundColor:uint = 0xFFFFFF;
        public function get backgroundColor():uint
        {
            return _backgroundColor;
        }
        public function set backgroundColor(value:uint):void
        {
            _backgroundColor = value;
        }
        
        private var _highlightColor:uint = 0xCEDBEF;
        public function get highlightColor():uint
        {
            return _highlightColor;
        }
        public function set highlightColor(value:uint):void
        {
            _highlightColor = value;
        }
        
        private var _selectedColor:uint = 0xA8C6EE;
        public function get selectedColor():uint
        {
            return _selectedColor;
        }
        public function set selectedColor(value:uint):void
        {
            _selectedColor = value;
        }
        
        private var _downColor:uint = 0x808080;
        public function get downColor():uint
        {
            return _downColor;
        }
        public function set downColor(value:uint):void
        {
            _downColor = value;
        }
        
		protected var useColor:uint = backgroundColor;
		
		private var _data:Object;
		
        [Bindable("__NoChangeEvent__")]
		/**
		 *  The data being represented by this itemRenderer. This can be something simple like a String or
		 *  a Number or something very complex.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get data():Object
		{
			return _data;
		}
		public function set data(value:Object):void
		{
			_data = value;
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
		
		private var _labelField:String = "label";
		
		/**
		 * The name of the field within the data to use as a label. Some itemRenderers use this field to
		 * identify the value they should show while other itemRenderers ignore this if they are showing
		 * complex information.
		 */
		public function get labelField():String
		{
			return _labelField;
		}
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		private var _index:int;
		
		/**
		 *  The position with the dataProvider being shown by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get index():int
		{
			return _index;
		}
		public function set index(value:int):void
		{
			_index = value;
		}
		
		private var _hovered:Boolean;
		
		/**
		 *  Whether or not the itemRenderer is in a hovered state.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get hovered():Boolean
		{
			return _hovered;
		}
		public function set hovered(value:Boolean):void
		{
			_hovered = value;
			updateRenderer();
		}
		
		private var _selected:Boolean;
		
		/**
		 *  Whether or not the itemRenderer is in a selected state.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			updateRenderer();
		}
		
		private var _down:Boolean;
		
		/**
		 *  Whether or not the itemRenderer is in a down (or pre-selected) state.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get down():Boolean
		{
			return _down;
		}
		public function set down(value:Boolean):void
		{
			_down = value;
			updateRenderer();
		}
		
		/**
		 * @private
		 */
		public function updateRenderer():void
		{
			if (down)
				useColor = downColor;
			else if (hovered)
				useColor = highlightColor;
			else if (selected)
				useColor = selectedColor;
			else
				useColor = backgroundColor;
		}
		
		/**
		 * @private
		 */
		private function sizeChangeHandler(event:Event):void
		{
			adjustSize();
		}
		
		/**
		 *  This function is called whenever the itemRenderer changes size. Sub-classes should override
		 *  this method an handle the size change.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function adjustSize():void
		{
			// handle in subclass
		}
	}
}
