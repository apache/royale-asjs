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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.ISelectableItemRenderer;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;

	/**
	 *  SelectableItemRenderer bead handles selection and hover states for item renderers
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class SelectableItemRendererBeadBase implements IBead, ISelectableItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SelectableItemRendererBeadBase()
		{
		}

        protected var _strand:IStrand;

        /**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            
            var host:IEventDispatcher = value as IEventDispatcher;
            
            // very common for item renderers to be resized by their containers,
            host.addEventListener("widthChanged", sizeChangeHandler);
            host.addEventListener("heightChanged", sizeChangeHandler);
            host.addEventListener("sizeChanged", sizeChangeHandler);
            
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
