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
    import flash.display.DisplayObject;
    import flash.text.TextFieldType;
    
    import org.apache.royale.core.CSSTextField;
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IBeadController;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IRoyaleElement;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.MouseEvent;
    import org.apache.royale.events.utils.MouseEventConverter;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.html.beads.ITextItemRenderer;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	
	/**
	 *  The TextFieldItemRenderer class provides a org.apache.royale.html.TextField as an itemRenderer.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TextFieldItemRenderer extends CSSTextField implements ITextItemRenderer, IStrand, IUIBase, IRoyaleElement
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TextFieldItemRenderer()
		{
			super();
            type = TextFieldType.DYNAMIC;
            selectable = false;
            
            MouseEventConverter.setupInstanceConverters(this);
		}
                
        public var highlightColor:uint = 0xCEDBEF;
        public var selectedColor:uint = 0xA8C6EE;
        public var downColor:uint = 0x808080;
		
		private var _explicitWidth:Number;
		
        public function get royale_wrapper():Object
        {
            return this;
        }
        public function set royale_wrapper(value:Object):void
        {
            
        }
        
		/**
		 *  The explicitly set width (as opposed to measured width
		 *  or percentage width).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get explicitWidth():Number
		{
			if (isNaN(_explicitWidth))
			{
				var value:* = ValuesManager.valuesImpl.getValue(this, "width");
				if (value !== undefined) {
					_explicitWidth = Number(value);
				}
			}
			
			return _explicitWidth;
		}
		
		/**
		 *  @private
		 */
		public function set explicitWidth(value:Number):void
		{
			if (_explicitWidth == value)
				return;
			
			// width can be pixel or percent not both
			if (!isNaN(value))
				_percentWidth = NaN;
			
			_explicitWidth = value;
			
			dispatchEvent(new Event("explicitWidthChanged"));
		}
		
		private var _explicitHeight:Number;
		
		/**
		 *  The explicitly set width (as opposed to measured width
		 *  or percentage width).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get explicitHeight():Number
		{
			if (isNaN(_explicitHeight))
			{
				var value:* = ValuesManager.valuesImpl.getValue(this, "height");
				if (value !== undefined) {
					_explicitHeight = Number(value);
				}
			}
			
			return _explicitHeight;
		}
		
		/**
		 *  @private
		 */
		public function set explicitHeight(value:Number):void
		{
			if (_explicitHeight == value)
				return;
			
			// height can be pixel or percent not both
			if (!isNaN(value))
				_percentHeight = NaN;
			
			_explicitHeight = value;
			
			dispatchEvent(new Event("explicitHeightChanged"));
		}
		
		private var _percentWidth:Number;
		
		/**
		 *  The requested percentage width this component
		 *  should have in the parent container.  Note that
		 *  the actual percentage may be different if the 
		 *  total is more than 100% or if there are other
		 *  components with explicitly set widths.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		
		/**
		 *  @private
		 */
		public function set percentWidth(value:Number):void
		{
			if (_percentWidth == value)
				return;
			
			if (!isNaN(value))
				_explicitWidth = NaN;
			
			_percentWidth = value;
			
			dispatchEvent(new Event("percentWidthChanged"));
		}
		
		private var _percentHeight:Number;
		
		/**
		 *  The requested percentage height this component
		 *  should have in the parent container.  Note that
		 *  the actual percentage may be different if the 
		 *  total is more than 100% or if there are other
		 *  components with explicitly set heights.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		
		/**
		 *  @private
		 */
		public function set percentHeight(value:Number):void
		{
			if (_percentHeight == value)
				return;
			
			if (!isNaN(value))
				_explicitHeight = NaN;
			
			_percentHeight = value;
			
			dispatchEvent(new Event("percentHeightChanged"));
		}

        private var _width:Number;
		
		/**
		 * @private
		 */
        override public function get width():Number
        {
			if (isNaN(explicitWidth))
			{
				var w:Number = _width;
				if (isNaN(w)) w = $width;
				var metrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(this);
				return w + metrics.left + metrics.right;
			}
			else
				return explicitWidth;
        }
        override public function set width(value:Number):void
        {
			if (explicitWidth != value)
			{
				explicitWidth = value;
			}
			
			if (value != _width) {
				_width = value;
				dispatchEvent( new Event("widthChanged") );
			}
        }
		
		/**
		 * @private
		 */
        protected function get $width():Number
        {
            return super.width;
        }
        
        private var _height:Number;
		
		/**
		 * @private
		 */
        override public function get height():Number
        {
			if (isNaN(explicitHeight))
			{
				var h:Number = _height;
				if (isNaN(h)) h = $height;
				var metrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderAndPaddingMetrics(this);
				return h + metrics.top + metrics.bottom;
			}
			else
				return explicitHeight;
        }

        override public function set height(value:Number):void
        {
			if (explicitHeight != value)
			{
				explicitHeight = value;
			}
			
			if (_height != value) {
				_height = value;
				dispatchEvent(new Event("heightChanged"));
			}
        }
		
		/**
		 * @private
		 */
        protected function get $height():Number
        {
            return super.height;
        }

		/**
		 *  The String(data) for the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
        public function get data():Object
        {
            return text;
        }
        public function set data(value:Object):void
        {
            text = String(value);
        }

	private var _listData:Object;

		/**
		 *  Additional data about the list the itemRenderer may find useful.
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
		
		/**
		 * @private
		 */
		public function get labelField():String
		{
			return null;
		}
		public function set labelField(value:String):void
		{
			// nothing to do for this
		}
        
        private var _index:int;
        
		/**
		 *  An index value for the itemRenderer corresponding the data's position with its dataProvider.
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

        private var _hovered:Boolean;
        
		/**
		 *  Returns whether or not the itemRenderer is a "hovered" state.
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
		 *  Whether or not the itemRenderer should be represented in a selected state.
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
		 *  Whether or not the itemRenderer should be represented in a down (or pre-selected) state.
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
		
		private var _itemRendererOwnerView:IItemRendererOwnerView;
		
		/**
		 *  The view of the parent component of the itemRenderer. 
         *  This is not always the container that directly parents the
		 *  itemRenderers.  A List may have an internal DataGroup that
         *  parents the itemRenderers,
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get itemRendererOwnerView():IItemRendererOwnerView
		{
			return _itemRendererOwnerView;
		}
		public function set itemRendererOwnerView(value:IItemRendererOwnerView):void
		{
			_itemRendererOwnerView = value;
		}
        
		/**
		 * @private
		 */
        public function updateRenderer():void
        {
            background = (down || selected || hovered);
            if (down)
                backgroundColor = downColor;
            else if (hovered)
                backgroundColor = highlightColor;
            else if (selected)
                backgroundColor = selectedColor;
        }
        
		/**
		 * @private
		 */
        public function get element():IRoyaleElement
        {
            return this;
        }

        // beads declared in MXML are added to the strand.
        // from AS, just call addBead()
        public var beads:Array;
        
        private var _beads:Vector.<IBead>;
		
		/**
		 * @private
		 */
        public function addBead(bead:IBead):void
        {
            if (!_beads)
                _beads = new Vector.<IBead>;
            _beads.push(bead);
            bead.strand = this;
        }
        
		/**
		 * @private
		 */
        public function getBeadByType(classOrInterface:Class):IBead
        {
            for each (var bead:IBead in _beads)
            {
                if (bead is classOrInterface)
                    return bead;
            }
            return null;
        }
        
		/**
		 * @private
		 */
        public function removeBead(value:IBead):IBead	
        {
            var n:int = _beads.length;
            for (var i:int = 0; i < n; i++)
            {
                var bead:IBead = _beads[i];
                if (bead == value)
                {
                    _beads.splice(i, 1);
                    return bead;
                }
            }
            return null;
        }
        
		/**
		 * @private
		 */
        public function addedToParent():void
        {
            var c:Class;
            
            for each (var bead:IBead in beads)
                addBead(bead);
            
            dispatchEvent(new Event("beadsAdded"));

            // renderer has a default model (the 'data' property)
            // and it is essentially a view of that model, so it
            // only needs an assignable controller
            loadBeadFromValuesManager(IBeadController, "iBeadController", this);
        }
        
        /**
         *  @copy org.apache.royale.core.IUIBase#topMostEventDispatcher
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get topMostEventDispatcher():IEventDispatcher
        {
            if (!parent)
                return null;
            return IUIBase(parent).topMostEventDispatcher;
        }
        
        
        COMPILE::SWF
        {
        [SWFOverride(returns="flash.display.DisplayObjectContainer")]
        override public function get parent():IParent
        {
            return super.parent as IParent;
        }
        }

    }
}
