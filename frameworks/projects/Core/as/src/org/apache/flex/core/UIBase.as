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
	import flash.display.Sprite;
	import flash.display.Stage;
	
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.events.utils.MouseEventConverter;
	import org.apache.flex.utils.BeadMetrics;
	
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
     *  Set a different class for rollOver events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="rollOver", type="org.apache.flex.events.MouseEvent")]
    
    /**
     *  Set a different class for rollOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="rollOut", type="org.apache.flex.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseDown events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="mouseDown", type="org.apache.flex.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseUp events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="mouseUp", type="org.apache.flex.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseMove events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="mouseMove", type="org.apache.flex.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="mouseOut", type="org.apache.flex.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseOver events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="mouseOver", type="org.apache.flex.events.MouseEvent")]
    
    /**
     *  The UIBase class is the base class for most composite user interface
     *  components.  For the Flash Player, Buttons and Text controls may
     *  have a different base class and therefore may not extend UIBase.
     *  However all user interface components should implement IUIBase.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class UIBase extends Sprite implements IStrandWithModel, IEventDispatcher, IParentIUIBase, IStyleableObject, ILayoutChild
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function UIBase()
		{
			super();
            
            MouseEventConverter.setupInstanceConverters(this);
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
         *  @productversion FlexJS 0.0
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
		
		private var _width:Number;

        [Bindable("widthChanged")]
        [PercentProxy("percentWidth")]
        /**
         *  The width of the component.  If no width has been previously
         *  set the default width may be specified in the IValuesImpl
         *  or determined as the bounding box around all child
         *  components and graphics.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        override public function get width():Number
		{
			if (isNaN(explicitWidth))
			{
				var w:Number = _width;
				if (isNaN(w)) w = $width;
				var metrics:UIMetrics = BeadMetrics.getMetrics(this);
				return w + metrics.left + metrics.right;
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
         *  @productversion FlexJS 0.0
         */
		public function get $width():Number
		{
			return super.width;
		}
		
		private var _height:Number;

        [Bindable("heightChanged")]
        [PercentProxy("percentHeight")]
        /**
         *  The height of the component.  If no height has been previously
         *  set the default height may be specified in the IValuesImpl
         *  or determined as the bounding box around all child
         *  components and graphics.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function get height():Number
		{
			if (isNaN(explicitHeight))
			{
				var h:Number = _height;
				if (isNaN(h)) h = $height;
				var metrics:UIMetrics = BeadMetrics.getMetrics(this);
				return h + metrics.top + metrics.bottom;
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
         *  @productversion FlexJS 0.0
         */
		public function get $height():Number
		{
			return super.height;
		}
        
        /**
         *  @copy org.apache.flex.core.ILayoutChild#setHeight
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
         *  @copy org.apache.flex.core.ILayoutChild#setWidth
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
         *  @copy org.apache.flex.core.ILayoutChild#setWidthAndHeight
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
                if (_width == newWidth)
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
            if (!isNaN(_explicitWidth))
                return false;
            if (!isNaN(_percentWidth))
                return false;
            var value:* = ValuesManager.valuesImpl.getValue(this, "width");
            if (value !== undefined)
                return false;
            var left:* = ValuesManager.valuesImpl.getValue(this, "left");
            var right:* = ValuesManager.valuesImpl.getValue(this, "right");
            return (left === undefined || right === undefined);

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
            if (!isNaN(_explicitHeight))
                return false;
            if (!isNaN(_percentHeight))
                return false;
            var value:* = ValuesManager.valuesImpl.getValue(this, "height");
            if (value !== undefined)
                return false;
            var top:* = ValuesManager.valuesImpl.getValue(this, "top");
            var bottom:* = ValuesManager.valuesImpl.getValue(this, "bottom");
            return (top === undefined || bottom === undefined);          
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
        
		private var _model:IBeadModel;

        /**
         *  An IBeadModel that serves as the data model for the component.
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
                    if (c)
                    {
                        _view = (new c()) as IBeadView;
                        addBead(_view);
                    }
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
         *  An id property for MXML documents.
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
            if (_styles != value)
            {
                if (value is String)
                {
                    _styles = ValuesManager.valuesImpl.parseStyles(value as String);
                }
                else
                    _styles = value;
                dispatchEvent(new Event("stylesChanged"));
            }
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
         *  The classname.  Often used for CSS
         *  class selector lookups.
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
         *  @copy org.apache.flex.core.IUIBase#element
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
         *  @copy org.apache.flex.core.Application#beads
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
        
        /**
         *  @copy org.apache.flex.core.IStrand#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */        
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
            else if (bead is IBeadView)
                _view = bead as IBeadView;
			bead.strand = this;
			
			if (bead is IBeadView) {
				IEventDispatcher(this).dispatchEvent(new Event("viewChanged"));
			}
		}
		
        /**
         *  @copy org.apache.flex.core.IStrand#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.IStrand#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
         *  @copy org.apache.flex.core.IParent#addElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function addElement(c:Object, dispatchEvent:Boolean = true):void
		{
            if (c is IUIBase)
            {
                addChild(IUIBase(c).element as DisplayObject);
                IUIBase(c).addedToParent();
            }
            else
                addChild(c as DisplayObject);
		}
        
        /**
         *  @copy org.apache.flex.core.IParent#addElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
            {
                addChildAt(IUIBase(c).element as DisplayObject, index);
                IUIBase(c).addedToParent();
            }
            else
                addChildAt(c as DisplayObject, index);
        }
        
        /**
         *  @copy org.apache.flex.core.IParent#getElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getElementAt(index:int):Object
        {
            return getChildAt(index);
        }        
        
        /**
         *  @copy org.apache.flex.core.IParent#getElementIndex()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getElementIndex(c:Object):int
        {
            if (c is IUIBase)
                return getChildIndex(IUIBase(c).element as DisplayObject);
            else
                return getChildIndex(c as DisplayObject);
        }

        /**
         *  @copy org.apache.flex.core.IParent#removeElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function removeElement(c:Object, dispatchEvent:Boolean = true):void
        {
            if (c is IUIBase)
                removeChild(IUIBase(c).element as DisplayObject);
            else
                removeChild(c as DisplayObject);
        }
		
        /**
         *  @copy org.apache.flex.core.IParent#numElements
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get numElements():int
        {
            return numChildren;
        }
        
        /**
         *  The method called when added to a parent.  This is a good
         *  time to set up beads.
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
         *  A measurement bead, if one exists.
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
        
        private var _stageProxy:StageProxy;
        
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
            if (!_stageProxy)
            {
                _stageProxy = new StageProxy(stage);
                _stageProxy.addEventListener("removedFromStage", stageProxy_removedFromStageHandler);
            }
            
            return _stageProxy;
        }
        
        private function stageProxy_removedFromStageHandler(event:Event):void
        {
            _stageProxy = null;
        }
        
        protected function repeaterListener(event:Event):void
        {
            dispatchEvent(event);
        }
	}
}