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
package org.apache.royale.core
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IMeasurementBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
    import org.apache.royale.events.utils.MouseEventConverter;
	import org.apache.royale.events.IEventDispatcher;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Set a different class for click events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	[Event(name="click", type="org.apache.royale.events.MouseEvent")]

    /**
     *  The UIButtonBase class is the base class for most Buttons in a Royale
     *  application.  In Flash, these buttons extend SimpleButton and therefore
     *  do not support all of the Sprite APIs.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	COMPILE::SWF
	public class UIButtonBase extends SimpleButton implements IStrandWithModel, IEventDispatcher, IUIBase, IStyleableObject, ILayoutChild, IRoyaleElement
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function UIButtonBase(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			// mouseChildren = true;
			// mouseEnabled = true;
            MouseEventConverter.setupInstanceConverters(this);
		}

        [SWFOverride(returns="flash.display.DisplayObjectContainer")]
        override public function get parent():IParent
        {
            return super.parent as IParent;
        }
        
        public function get $displayObject():DisplayObject
        {
            return this;
        }
        
        public function get royale_wrapper():Object
        {
            return this;
        }
        public function set royale_wrapper(value:Object):void
        {
            
        }

        private var _x:Number;
        
		/**
		 *  @private
		 */
		override public function set x(value:Number):void
		{
			super.x = _x = value;
			if (!style)
				style = { left: value };
			else
				style.left = value;
			dispatchEvent(new Event("xChanged"));
		}
		
        private var _y:Number;

        /**
		 *  @private
		 */
		override public function set y(value:Number):void
		{
			super.y = _y = value;
			if (!style)
				style = { top: value };
			else
				style.top = value;
			dispatchEvent(new Event("yChanged"));
		}
		
		/**
		 *  Retrieve the low-level bounding box y.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		protected function get $y():Number
		{
			return super.y;
		}
		
		private var _explicitWidth:Number;
		
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
        
		[Bindable("widthChanged")]
        [PercentProxy("percentWidth")]
        /**
         *  @copy org.apache.royale.core.UIBase#width
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function get width():Number
		{
			if (isNaN(explicitWidth))
			{
				var w:Number = _width;
				if (isNaN(w)) w = $width;
				return w;
			}
			else
				return explicitWidth;
		}

        /**
         *  @private
         */
		override public function set width(value:Number):void
		{
			if (explicitWidth != value)
			{
				explicitWidth = value;
			}
			
			setWidth(value);
		}

        /**
         *  Retrieve the low-level bounding box width.
         *  Not implemented in JS.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get $width():Number
		{
			return super.width;
		}
		
		private var _height:Number;

		[Bindable("heightChanged")]
        [PercentProxy("percentHeight")]
        /**
         *  @copy org.apache.royale.core.UIBase#width
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function get height():Number
		{
			if (isNaN(explicitHeight))
			{
				var h:Number = _height;
				if (isNaN(h)) h = $height;
				return h;
			}
			else
				return explicitHeight;
		}
        
        /**
         *  @private
         */
		override public function set height(value:Number):void
		{
			if (explicitHeight != value)
			{
				explicitHeight = value;
			}
			
			setHeight(value);
		}
        
        /**
         *  Retrieve the low-level bounding box height.
         *  Not implemented in JS.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get $height():Number
		{
			return super.height;
		}

        /**
         * @private
         * Used by layout to prevent causing unnecessary reflows when measuring.
         */
        private var _measuredWidth:Number;

		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}

		public function set measuredWidth(value:Number):void
		{
			_measuredWidth = value;
		}
        /**
         * @private
         * Used by layout to prevent causing unnecessary reflows when measuring.
         */
        private var _measuredHeight:Number;

		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}

		public function set measuredHeight(value:Number):void
		{
			_measuredHeight = value;
		}

        /**
         *  @copy org.apache.royale.core.IUIBase#setHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setHeight(value:Number, noEvent:Boolean = false):void
        {
            if (_height != value)
            {
                _height = value;
                if (!noEvent)
                    dispatchEvent(new Event("heightChanged"));
            }            
        }
        
        /**
         *  @copy org.apache.royale.core.IUIBase#setWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setWidth(value:Number, noEvent:Boolean = false):void
        {
            if (_width != value)
            {
                _width = value;
                if (!noEvent)
                    dispatchEvent(new Event("widthChanged"));
            }
        }
        
        /**
         *  @copy org.apache.royale.core.IUIBase#setWidthAndHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setWidthAndHeight(newWidth:Number, newHeight:Number, noEvent:Boolean = false):void
        {
            if (_width != newWidth)
            {
                _width = newWidth;
                if (_height == newHeight)
                    if (!noEvent) 
                        dispatchEvent(new Event("widthChanged"));
            }
            if (_height != newHeight)
            {
                _height = newHeight;
                if (!noEvent)
                    dispatchEvent(new Event("heightChanged"));
            }            
            dispatchEvent(new Event("sizeChanged"));
        }
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#isWidthSizedToContent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function isWidthSizedToContent():Boolean
        {
            return (isNaN(_explicitWidth) && isNaN(_percentWidth));
        }
		        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setX
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setX(value:Number):void
        {
            super.x = value;
        }
                
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setY
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setY(value:Number):void
        {
            super.y = value;
        }
        
		/**
		 * @private
		 */
        [Bindable("visibleChanged")]
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			dispatchEvent(new Event(value?"show":"hide"));
			dispatchEvent(new Event("visibleChanged"));
		}
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#isHeightSizedToContent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function isHeightSizedToContent():Boolean
        {
            return (isNaN(_explicitHeight) && isNaN(_percentHeight));
        }
        
        private var _model:IBeadModel;

        /**
         *  @copy org.apache.royale.core.UIBase#model
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get model():Object
        {
            if (_model == null)
            {
                // addbead will set _model
                addBead(new (ValuesManager.valuesImpl.getValue(this, "iBeadModel")) as IBead);
            }
            return _model;
        }

        /**
         *  @private
         */
        public function set model(value:Object):void
        {
            if (_model != value)
            {
                addBead(value as IBead);
                dispatchEvent(new Event("modelChanged"));
            }
        }
		
        private var _view:IBeadView;
        
        /**
         *  An IBeadView that serves as the view for the component.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get view():IBeadView
        {
            if (_view == null)
            {
                var c:Class = ValuesManager.valuesImpl.getValue(this, "iBeadView") as Class;
                if (c)
                {
                    _view = (new c()) as IBeadView;
                    addBead(_view);
                }
            }
            return _view;
        }
        
        /**
         *  @private
         */
        public function set view(value:IBeadView):void
        {
            if (_view != value)
            {
                addBead(value as IBead);
                dispatchEvent(new Event("viewChanged"));
            }
        }
        
		private var _id:String;

        /**
         *  @copy org.apache.royale.core.UIBase#id
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get id():String
		{
			return _id;
		}

        /**
         *  @private
         */
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
		}

        private var _styles:Object;
        
        /**
         *  The object that contains
         *  "styles" and other associated
         *  name-value pairs.  You can
         *  also specify a string in
         *  HTML style attribute format.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get style():Object
        {
            return _styles;
        }
        
        /**
         *  @private
         */
        public function set style(value:Object):void
        {
            if (value is String)
                _styles = ValuesManager.valuesImpl.parseStyles(value as String);
            else
                _styles = value;
            if (!isNaN(_y))
                _styles.top = _y;
            if (!isNaN(_x))
                _styles.left = _x;
            dispatchEvent(new Event("stylesChanged"));
        }
        
        /**
         *  The styles for this object formatted
         *  as an HTML style attribute.  While this
         *  may be a convenient and less verbose
         *  way of specifying styles than using
         *  the style object, you run the risk of
         *  having a typo.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set styleString(value:String):void
        {
            _styles = JSON.parse("{" + value + "}");
        }
        
        /**
         *  A list of type names.  Often used for CSS
         *  type selector lookups.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var typeNames:String;
        
		private var _className:String;

        /**
         *  @copy org.apache.royale.core.UIBase#className
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get className():String
		{
			return _className;
		}

        /**
         *  @private
         */
		public function set className(value:String):void
		{
			if (_className != value)
			{
				_className = value;
				dispatchEvent(new Event("classNameChanged"));
			}
		}
        
        /**
         *  @copy org.apache.royale.core.UIBase#element
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get element():IRoyaleElement
        {
            return this;
        }

        /**
         *  @copy org.apache.royale.core.UIBase#beads
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var beads:Array;
        
		private var strand:Vector.<IBead>;

        /**
         *  @copy org.apache.royale.core.UIBase#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function addBead(bead:IBead):void
		{
			if (!strand)
				strand = new Vector.<IBead>;
			strand.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
            else if (bead is IBeadView)
                _view = bead as IBeadView;
			bead.strand = this; // super.addBead already did this!
		}
		
        /**
         *  @copy org.apache.royale.core.UIBase#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in strand)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
        /**
         *  @copy org.apache.royale.core.UIBase#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function removeBead(value:IBead):IBead	
		{
			var n:int = strand.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = strand[i];
				if (bead == value)
				{
					strand.splice(i, 1);
					return bead;
				}
			}
			return null;
		}
		
        /**
         *  @copy org.apache.royale.core.UIBase#addToParent()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function addedToParent():void
		{
            var c:Class;
            
            for each (var bead:IBead in beads)
                addBead(bead);
            
            if (getBeadByType(IBeadModel) == null) 
            {
                c = ValuesManager.valuesImpl.getValue(this, "iBeadModel") as Class;
                if (c)
                {
                    var model:IBeadModel = new c as IBeadModel;
                    if (model)
                        addBead(model);
                }
            }
            if (getBeadByType(IBeadView) == null) 
            {
                c = ValuesManager.valuesImpl.getValue(this, "iBeadView") as Class;
                if (c)
                {
                    var view:IBeadView = new c as IBeadView;
                    if (view)
                        addBead(view);
                }
            }
            if (getBeadByType(IBeadController) == null) 
            {
                c = ValuesManager.valuesImpl.getValue(this, "iBeadController") as Class;
                if (c)
                {
                    var controller:IBeadController = new c as IBeadController;
                    if (controller)
                        addBead(controller);
                }
            }

            dispatchEvent(new Event("beadsAdded"));
            
		}
		
        /**
         *  @copy org.apache.royale.core.UIBase#measurementBead
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get measurementBead() : IMeasurementBead
		{
			var measurementBead:IMeasurementBead = getBeadByType(IMeasurementBead) as IMeasurementBead;
			if( measurementBead == null ) {
				addBead(measurementBead = new (ValuesManager.valuesImpl.getValue(this, "iMeasurementBead")) as IMeasurementBead);
			}
			
			return measurementBead;
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

        
	}
}
