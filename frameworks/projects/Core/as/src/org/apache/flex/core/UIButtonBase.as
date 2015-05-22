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
package org.apache.flex.core
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IMeasurementBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
    import org.apache.flex.events.utils.MouseEventConverter;
	import org.apache.flex.events.IEventDispatcher;
	
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
     *  @productversion FlexJS 0.0
     */
	[Event(name="click", type="org.apache.flex.events.MouseEvent")]

    /**
     *  The UIButtonBase class is the base class for most Buttons in a FlexJS
     *  application.  In Flash, these buttons extend SimpleButton and therefore
     *  do not support all of the Sprite APIs.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class UIButtonBase extends SimpleButton implements IStrandWithModel, IEventDispatcher, IUIBase, IStyleableObject, ILayoutChild
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function UIButtonBase(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
			// mouseChildren = true;
			// mouseEnabled = true;
            MouseEventConverter.setupInstanceConverters(this);
		}
				
		/**
		 *  @private
		 */
		override public function set x(value:Number):void
		{
			if (super.x != value) {
				super.x = value;
				dispatchEvent(new Event("xChanged"));
			}
		}
		
		/**
		 *  @private
		 */
		override public function set y(value:Number):void
		{
			if (super.y != value) {
				super.y = value;
				dispatchEvent(new Event("yChanged"));
			}
		}
		
		/**
		 *  Retrieve the low-level bounding box y.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
		 */
		public function get explicitWidth():Number
		{
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
		 *  @productversion FlexJS 0.0
		 */
		public function get explicitHeight():Number
		{
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		
		/**
		 * Returns the inner width of the component which includes its padding but
		 * not its margins. Basically, the width plus left and right padding.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get clientWidth():Number
		{			
            // button views should already factor in padding to set
            // the borders
			return width;
		}
		
		/**
		 * Returns the inner height of the component which includes its padding
		 * but not its margins. Basically, the height plus top and bottom padding.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get clientHeight():Number
		{
            // button views should already factor in padding to set
            // the borders
			return height;
		}
		
		private var _width:Number;
        
        [PercentProxy("percentWidth")]
        /**
         *  @copy org.apache.flex.core.UIBase#width
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function get width():Number
		{
            if (isNaN(_width))
            {
                var value:* = ValuesManager.valuesImpl.getValue(this, "width");
                if (value === undefined)
                {
                    if (view)
                        return view.viewWidth;
                    return $width;
                }
                _width = Number(value);
            }
            return _width;
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
			
			if (_width != value)
			{
				_width = value;
				dispatchEvent(new Event("widthChanged"));
			}
		}

        /**
         *  Retrieve the low-level bounding box width.
         *  Not implemented in JS.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get $width():Number
		{
			return super.width;
		}
		
		private var _height:Number;

        [PercentProxy("percentHeight")]
        /**
         *  @copy org.apache.flex.core.UIBase#width
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function get height():Number
		{
            if (isNaN(_height))
            {
                var value:* = ValuesManager.valuesImpl.getValue(this, "height");
                if (value === undefined)
                {
                    if (view)
                        return view.viewHeight;
                    return $height;
                }
                _height = Number(value);
            }
            return _height;
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
			
			if (_height != value)
			{
				_height = value;
				dispatchEvent(new Event("heightChanged"));
			}
		}
        
        /**
         *  Retrieve the low-level bounding box height.
         *  Not implemented in JS.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get $height():Number
		{
			return super.height;
		}

        /**
         *  @copy org.apache.flex.core.IUIBase#setHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.IUIBase#setWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.IUIBase#setWidthAndHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.ILayoutChild#isWidthSizedToContent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function isWidthSizedToContent():Boolean
        {
            return (isNaN(_explicitWidth) && isNaN(_percentWidth));
        }
		
		/**
		 * @private
		 */
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			dispatchEvent(new Event(value?"show":"hide"));
			dispatchEvent(new Event("visibleChanged"));
		}
        
        /**
         *  @copy org.apache.flex.core.ILayoutChild#isHeightSizedToContent
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function isHeightSizedToContent():Boolean
        {
            return (isNaN(_explicitHeight) && isNaN(_percentHeight));
        }
		
		/**
		 *  Determines the top and left padding values, if any, as set by
		 *  padding style values. This includes "padding" for all padding values
		 *  as well as "padding-left" and "padding-top".
		 * 
		 *  Returns an object with paddingLeft and paddingTop properties.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		protected function determinePadding():Object
		{
			var paddingLeft:Object;
			var paddingTop:Object;
			var paddingRight:Object;
			var paddingBottom:Object;
			var padding:Object = ValuesManager.valuesImpl.getValue(this, "padding");
			if (padding is Array)
			{
				if (padding.length == 1)
					paddingLeft = paddingTop = padding[0];
				else if (padding.length <= 3)
				{
					paddingLeft = padding[1];
					paddingTop = padding[0];
				}
				else if (padding.length == 4)
				{
					paddingLeft = padding[3];
					paddingTop = padding[0];					
				}
			}
			else if (padding == null)
			{
				paddingLeft = ValuesManager.valuesImpl.getValue(this, "padding-left");
				paddingTop = ValuesManager.valuesImpl.getValue(this, "padding-top");
				paddingRight = ValuesManager.valuesImpl.getValue(this, "padding-right");
				paddingBottom = ValuesManager.valuesImpl.getValue(this, "padding-bottom");
			}
			else
			{
				paddingLeft = paddingTop = padding;
				paddingRight = paddingBottom = padding;
			}
			var pl:Number = Number(paddingLeft);
			var pt:Number = Number(paddingTop);
			var pr:Number = Number(paddingRight);
			var pb:Number = Number(paddingBottom);
			
			return {paddingLeft:pl, paddingTop:pt, paddingRight:pr, paddingBottom:pb};
		}
        
        private var _model:IBeadModel;

        /**
         *  @copy org.apache.flex.core.UIBase#model
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get model():IBeadModel
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
        public function set model(value:IBeadModel):void
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
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.UIBase#id
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
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
         *  @productversion FlexJS 0.0
         */
        public var typeNames:String;
        
		private var _className:String;

        /**
         *  @copy org.apache.flex.core.UIBase#className
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.UIBase#element
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get element():Object
        {
            return this;
        }

        /**
         *  @copy org.apache.flex.core.UIBase#beads
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var beads:Array;
        
		private var strand:Vector.<IBead>;

        /**
         *  @copy org.apache.flex.core.UIBase#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
			bead.strand = this;
		}
		
        /**
         *  @copy org.apache.flex.core.UIBase#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.UIBase#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.UIBase#addToParent()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.UIBase#measurementBead
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.IUIBase#topMostEventDispatcher
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get topMostEventDispatcher():IEventDispatcher
        {
            if (!parent)
                return null;
            return IUIBase(parent).topMostEventDispatcher;
        }

        
	}
}