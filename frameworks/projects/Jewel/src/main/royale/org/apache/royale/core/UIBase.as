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
    COMPILE::SWF
    {
        import flash.display.DisplayObject;
        import flash.display.Sprite;
        import flash.display.Stage;
        import org.apache.royale.events.utils.MouseEventConverter;
    }
	
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.utils.loadBeadFromValuesManager;
    import org.apache.royale.utils.StringUtil;

    COMPILE::JS
    {
        import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.utils.CSSUtils;
    }
	
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
     *  Set a different class for rollOver events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="rollOver", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for rollOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="rollOut", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseDown events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="mouseDown", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseUp events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="mouseUp", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseMove events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="mouseMove", type="org.apache.royale.events.MouseEvent")]
    
    /**
     *  Set a different class for mouseOut events so that
     *  there aren't dependencies on the flash classes
     *  on the JS side.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="mouseOut", type="org.apache.royale.events.MouseEvent")]
    
	/**
	 *  Set a different class for mouseOver events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="mouseOver", type="org.apache.royale.events.MouseEvent")]
	/**
	 *  Set a different class for mouseWheel events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="mouseWheel", type="org.apache.royale.events.MouseEvent")]
	
	/**
	 *  Set a different class for doubleClick events so that
	 *  there aren't dependencies on the flash classes
	 *  on the JS side.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="doubleClick", type="org.apache.royale.events.MouseEvent")]
	
    /**
     *  The UIBase class is the base class for most composite user interface
     *  components.  For the Flash Player, Buttons and Text controls may
     *  have a different base class and therefore may not extend UIBase.
     *  However all user interface components should implement IUIBase.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class UIBase extends HTMLElementWrapper implements IStrandWithModel, IEventDispatcher, IParentIUIBase, IStyleableObject, ILayoutChild, IRoyaleElement
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function UIBase()
		{
			super();
            
            COMPILE::SWF
            {
                MouseEventConverter.setupInstanceConverters(this);
                doubleClickEnabled = true; // make JS and flash consistent
            }
            
            COMPILE::JS
            {
                createElement();
            }
        }
        
        COMPILE::SWF
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
			COMPILE::SWF {
				if (_percentWidth == value)
					return;
				
				if (!isNaN(value))
					_explicitWidth = NaN;
				
				_percentWidth = value;
			}
			COMPILE::JS {
				this._percentWidth = value;
				this.positioner.style.width = value.toString() + '%';
				if (!isNaN(value))
					this._explicitWidth = NaN;
			}
			
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
			COMPILE::SWF {
				if (_percentHeight == value)
					return;
				
				if (!isNaN(value))
					_explicitHeight = NaN;
				
				_percentHeight = value;
			}
				
			COMPILE::JS {
				this._percentHeight = value;
				this.positioner.style.height = value.toString() + '%';
				if (!isNaN(value))
					this._explicitHeight = NaN;
			}
			
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
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
        override public function get width():Number
		{
			var w:Number = _width;
			if (isNaN(w)) {
				w = $width;
			}
			return w;
		}
        
        [Bindable("widthChanged")]
        [PercentProxy("percentWidth")]
        /**
         * @royaleignorecoercion String
         */
        COMPILE::JS
        public function get width():Number
        {
            var pixels:Number;
            var strpixels:String = element.style.width as String;
            if(strpixels == null)
                pixels = NaN;
            else
                pixels = CSSUtils.toNumber(strpixels,NaN);
            if (isNaN(pixels)) {
                pixels = positioner.offsetWidth;
                if (pixels == 0 && positioner.scrollWidth != 0) {
                    // invisible child elements cause offsetWidth to be 0.
                    pixels = positioner.scrollWidth;
                }
            }
            return pixels;
        }

        /**
         *  @private
         */
        COMPILE::SWF
		override public function set width(value:Number):void
		{
			if (explicitWidth !== value)
			{
				explicitWidth = value;
			}
			
            setWidth(value);
		}
        
        /**
         *  @private
         */
        COMPILE::JS
        public function set width(value:Number):void
        {
            if (explicitWidth !== value)
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
        COMPILE::SWF
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
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
		override public function get height():Number
		{
			var h:Number = _height;
			if (isNaN(h)) {
				h = $height;
			}
			return h;
		}
        
        [Bindable("heightChanged")]
        [PercentProxy("percentHeight")]
        /**
         * @royaleignorecoercion String
         */
        COMPILE::JS
        public function get height():Number
        {
            var pixels:Number;
            var strpixels:String = element.style.height as String;
            if(strpixels == null)
                pixels = NaN;
            else
                pixels = CSSUtils.toNumber(strpixels,NaN);
            if (isNaN(pixels)) {
                pixels = positioner.offsetHeight;
                if (pixels == 0 && positioner.scrollHeight != 0) {
                    // invisible child elements cause offsetHeight to be 0.
                    pixels = positioner.scrollHeight;
                }
            }
            return pixels;
        }

        /**
         *  @private
         */
        COMPILE::SWF
		override public function set height(value:Number):void
		{
			if (explicitHeight !== value)
			{
				explicitHeight = value;
			}
			
            setHeight(value);
		}
        
        /**
         *  @private
         */
        COMPILE::JS
        public function set height(value:Number):void
        {
            if (explicitHeight !== value)
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
        COMPILE::SWF
		public function get $height():Number
		{
			return super.height;
		}
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setHeight(value:Number, noEvent:Boolean = false):void
        {
            if (_height !== value)
            {
                _height = value;
                COMPILE::JS
                {
                    this.positioner.style.height = value.toString() + 'px';        
                }
                if (!noEvent)
                    dispatchEvent(new Event("heightChanged"));
            }            
        }

        /**
         *  @copy org.apache.royale.core.ILayoutChild#setWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setWidth(value:Number, noEvent:Boolean = false):void
        {
            if (_width !== value)
            {
                _width = value;
                COMPILE::JS
                {
                    this.positioner.style.width = value.toString() + 'px';        
                }
                if (!noEvent)
                    dispatchEvent(new Event("widthChanged"));
            }
        }
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setWidthAndHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function setWidthAndHeight(newWidth:Number, newHeight:Number, noEvent:Boolean = false):void
        {
            if (_width !== newWidth)
            {
                _width = newWidth;
                COMPILE::JS
                {
                    this.positioner.style.width = newWidth.toString() + 'px';        
                }
                if (!noEvent) 
                    dispatchEvent(new Event("widthChanged"));
            }
            if (_height !== newHeight)
            {
                _height = newHeight;
                COMPILE::JS
                {
                    this.positioner.style.height = newHeight.toString() + 'px';        
                }
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
            if (!isNaN(_explicitWidth))
                return false;
            if (!isNaN(_percentWidth))
                return false;
            var left:* = ValuesManager.valuesImpl.getValue(this, "left");
            var right:* = ValuesManager.valuesImpl.getValue(this, "right");
            return (left === undefined || right === undefined);

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
            if (!isNaN(_explicitHeight))
                return false;
            if (!isNaN(_percentHeight))
                return false;
            var top:* = ValuesManager.valuesImpl.getValue(this, "top");
            var bottom:* = ValuesManager.valuesImpl.getValue(this, "bottom");
            return (top === undefined || bottom === undefined);          
        }
		
        private var _x:Number;
        
        /**
         *  @private
         */
        COMPILE::SWF
        override public function set x(value:Number):void
        {
            super.x = _x = value;
            if (!style)
                style = { left: value };
            else
                style.left = value;
        }
        
        /**
         * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        public function set x(value:Number):void
        {
            //positioner.style.position = 'absolute';
            if (positioner.parentNode != positioner.offsetParent)
                value += (positioner.parentNode as HTMLElement).offsetLeft;
            positioner.style.left = value.toString() + 'px';
        }

        /**
         * @royaleignorecoercion String
         * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        public function get x():Number
        {
            var strpixels:String = positioner.style.left as String;
            var pixels:Number = parseFloat(strpixels);
            if (isNaN(pixels))
            {
                pixels = positioner.offsetLeft;
                if (positioner.parentNode != positioner.offsetParent)
                    pixels -= (positioner.parentNode as HTMLElement).offsetLeft;
            }
            return pixels;
        }
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setX
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
         */
        public function setX(value:Number):void
        {
			COMPILE::SWF
			{
				super.x = value;					
			}
			COMPILE::JS
			{
				//positioner.style.position = 'absolute';
                if (positioner.parentNode != positioner.offsetParent)
                    value += (positioner.parentNode as HTMLElement).offsetLeft;
				positioner.style.left = value.toString() + 'px';
			}
        }
        
        private var _y:Number;
        
        /**
         *  @private
         */
        COMPILE::SWF
        override public function set y(value:Number):void
        {
            super.y = _y = value;
            if (!style)
                style = { top: value };
            else
                style.top = value;
        }
        
        /**
         * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        public function set y(value:Number):void
        {
            //positioner.style.position = 'absolute';
            if (positioner.parentNode != positioner.offsetParent)
                value += (positioner.parentNode as HTMLElement).offsetTop;
            positioner.style.top = value.toString() + 'px';
        }
        
        /**
         * @royaleignorecoercion String
         * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        public function get y():Number
        {
            var strpixels:String = positioner.style.top as String;
            var pixels:Number = parseFloat(strpixels);
            if (isNaN(pixels))
            {
                pixels = positioner.offsetTop;
                if (positioner.parentNode != positioner.offsetParent)
                    pixels -= (positioner.parentNode as HTMLElement).offsetTop;
            }
            return pixels;
        }
        
        /**
         *  @copy org.apache.royale.core.ILayoutChild#setY
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
         */
        public function setY(value:Number):void
        {
			COMPILE::SWF
			{
				super.y = value;					
			}
			COMPILE::JS
			{
				//positioner.style.position = 'absolute';
                if (positioner.parentNode != positioner.offsetParent)
                    value += (positioner.parentNode as HTMLElement).offsetTop;
				positioner.style.top = value.toString() + 'px';				
			}
        }
        
		/**
		 * @private
		 */
        [Bindable("visibleChanged")]
        COMPILE::SWF
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			dispatchEvent(new Event(value?"show":"hide"));
			dispatchEvent(new Event("visibleChanged"));
        }
        
        COMPILE::JS
        private var displayStyleForLayout:String;
		
		/**
		 *  The display style is used for both visible
		 *  and layout so is managed as a special case.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		public function setDisplayStyleForLayout(value:String):void
		{
			if (positioner.style.display !== 'none')
				positioner.style.display = value;
			else
				displayStyleForLayout = value;
		}
        
        [Bindable("visibleChanged")]
        COMPILE::JS
        public function get visible():Boolean
        {
            return positioner.style.display !== 'none';
        }
        
        COMPILE::JS
        public function set visible(value:Boolean):void
        {
            var oldValue:Boolean = positioner.style.display !== 'none';
            if (value !== oldValue) 
            {
                if (!value) 
                {
					displayStyleForLayout = positioner.style.display;
                    positioner.style.display = 'none';
                    dispatchEvent(new Event('hide'));
                } 
                else 
                {
                    if (displayStyleForLayout != null)
                        positioner.style.display = displayStyleForLayout;
                    dispatchEvent(new Event('show'));
                }
                dispatchEvent(new Event('visibleChanged'));
            }
        }
        
        /**
         * @return The array of children.
         * @royaleignorecoercion Array
         */
        COMPILE::JS
        public function internalChildren():Array
        {
            return element.childNodes as Array;
        }
        
        COMPILE::SWF
		private var _model:IBeadModel;

        /**
         *  An IBeadModel that serves as the data model for the component.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
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
        COMPILE::SWF
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
         *  @royaleignorecoercion Class
         */
        public function get view():IBeadView
        {
            if(!_view)
                _view = loadBeadFromValuesManager(IBeadView, "iBeadView", this) as IBeadView;
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
			if (_id !== value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
            COMPILE::JS
            {
                element.id = _id;
            }
		}
		
        private var _style:Object;
        
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
            return _style;
        }
        
        /**
         *  @private
         *  @royaleignorecoercion String
         */
        public function set style(value:Object):void
        {
            if (_style !== value)
            {
                if (value is String)
                {
                    _style = ValuesManager.valuesImpl.parseStyles(value as String);
                }
                else
                    _style = value;
                if (!isNaN(_y))
                    _style.top = _y;
                if (!isNaN(_x))
                    _style.left = _x;
				COMPILE::JS
				{
					if (parent)
						ValuesManager.valuesImpl.applyStyles(this, _style);
				}
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
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
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
            if (_className !== value)
            {
                _className = value;

                COMPILE::JS
                {
                    setClassName(computeFinalClassNames());             
                }
                
                dispatchEvent(new Event("classNameChanged"));
            }
        }

        /**
         *  Computes the final syles for this component joining typeNames and classNames
         *  styles
         *  
         *  @langversion 3.0
         *  @productversion Royale 0.9.3
         */
        COMPILE::JS
        protected function computeFinalClassNames():String
		{
            return  StringUtil.trim((_className ? _className : "") + " " + (typeNames ? typeNames : ""));
		}

        /**
         *  Sets the component styles in JS
         *  
         *  @langversion 3.0
         *  @productversion Royale 0.0
         */
        COMPILE::JS
        protected function setClassName(value:String):void
        {
            addStyles(value);
        }

        /**
         *  Add one or more styles to the component. If the specified class already 
         *  exist, the class will not be added.
         *  
         *  @param value, a String with the style (or styles separated by an space) to
         *  add from the component. If the string is empty doesn't perform any action
         *  
         *  @langversion 3.0
         *  @productversion Royale 0.9.3
         */
        COMPILE::JS
        protected function addStyles(value:String):void
        {
            if (value == "") return;
            
            if (value.indexOf(" ") >= 0)
            {
                var classes:Array = value.split(" ");
                element.classList.add.apply(element.classList, classes);
            } else
            {
                element.classList.add(value);
            }
        }

        /**
         *  Removes one or more styles from the component. Removing a class that does not 
         *  exist, does not throw any error
         * 
         *  @param value, a String with the style (or styles separated by an space) to 
         *  remove from the component. If the string is empty doesn't perform any action
         *  
         *  @langversion 3.0
         *  @productversion Royale 0.9.3
         */
        COMPILE::JS
        protected function removeStyles(value:String):void
        {
            if (value == "") return;

            if (value.indexOf(" ") >= 0)
            {
                var classes:Array = value.split(" ");
                element.classList.remove.apply(element.classList, classes);
            } else
            {
                element.classList.remove(value);
            }
        }

        /**
         *  Adds or removes a single style. 
         * 
         *  The first parameter removes the style from an element, and returns false.
         *  If the style does not exist, it is added to the element, and the return value is true.
         * 
         *  The optional second parameter is a Boolean value that forces the class to be added 
         *  or removed, regardless of whether or not it already existed.
         * 
         *  @langversion 3.0
         *  @productversion Royale 0.9.3
         */
        COMPILE::JS
        protected function toggleStyle(value:String, force:Boolean = false):Boolean
        {
            return element.classList.toggle(value, force);
        }

        /**
         *  Removes all styles that are not in typeNames
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::JS
        protected function removeAllStyles():void
        {
            var classList:DOMTokenList = element.classList;
            var i:int;
            for( i = classList.length; i > 0; i-- )
            {
                if(typeNames.indexOf(classList[i]) != 0)
                {
                    classList.remove(classList[i]);
                }
            }
        }

        /**
         *  @copy org.apache.royale.core.IUIBase#element
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
        public function get element():IRoyaleElement
        {
            return this;
        }
		
        /**
         *  @copy org.apache.royale.core.Application#beads
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */
		public var beads:Array;
		
        COMPILE::SWF
		private var _beads:Vector.<IBead>;
        
        /**
         *  @copy org.apache.royale.core.IStrand#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
		override public function addBead(bead:IBead):void
		{
            var isView:Boolean;
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			if (bead is IBeadModel)
				_model = bead as IBeadModel;
            else if (bead is IBeadView)
            {
                _view = bead as IBeadView;
                isView = true
            }
			bead.strand = this;
			
			if (isView) {
				IEventDispatcher(this).dispatchEvent(new Event("viewChanged"));
			}
		}
		
        /**
         *  @copy org.apache.royale.core.IStrand#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
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
         *  @copy org.apache.royale.core.IStrand#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
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
         *  @copy org.apache.royale.core.IParent#addElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
		public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
            COMPILE::SWF
            {
                if (c is IUIBase)
                {
                    if (c is IRenderedObject)
                        addChild(IRenderedObject(c).$displayObject);
                    else
                        addChild(c as DisplayObject);                        
                    IUIBase(c).addedToParent();
                }
                else
                    addChild(c as DisplayObject);
            }
            COMPILE::JS
            {
                element.appendChild(c.positioner);
                (c as IUIBase).addedToParent();
            }
		}
        
        /**
         *  @copy org.apache.royale.core.IParent#addElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF
            {
                if (c is IUIBase)
                {
                    if (c is IRenderedObject)
                        addChildAt(IUIBase(c).$displayObject, index);
                    else
                        addChildAt(c as DisplayObject, index);
                    IUIBase(c).addedToParent();
                }
                else
                    addChildAt(c as DisplayObject, index);
            }
            COMPILE::JS
            {
                var children:Array = internalChildren();
                if (index >= children.length)
                    addElement(c);
                else
                {
                    element.insertBefore(c.positioner,
                        children[index]);
                    (c as IUIBase).addedToParent();
                }
            }
        }
        
        /**
         *  @copy org.apache.royale.core.IParent#getElementAt()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getElementAt(index:int):IChild
        {
            COMPILE::SWF
            {
                return getChildAt(index) as IChild;
            }
            COMPILE::JS
            {
                var children:Array = internalChildren();
                if (children.length == 0)
                {
                    return null;
                }
                return children[index].royale_wrapper;
            }
        }        
        
        /**
         *  @copy org.apache.royale.core.IParent#getElementIndex()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function getElementIndex(c:IChild):int
        {
            COMPILE::SWF
            {
                if (c is IRenderedObject)
                    return getChildIndex(IRenderedObject(c).$displayObject);
                else
                    return getChildIndex(c as DisplayObject);
            }
            COMPILE::JS
            {
                var children:Array = internalChildren();
                var n:int = children.length;
                for (var i:int = 0; i < n; i++)
                {
                    if (children[i] === c.element)
                        return i;
                }
                return -1;                
            }
        }

        /**
         *  @copy org.apache.royale.core.IParent#removeElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 *  @royaleignorecoercion HTMLElement
         */
        public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            COMPILE::SWF
            {
                if (c is IRenderedObject)
                    removeChild(IRenderedObject(c).$displayObject);
                else
                    removeChild(c as DisplayObject);
            }
            COMPILE::JS
            {
                element.removeChild(c.element as HTMLElement);
            }
        }
		
        /**
         *  @copy org.apache.royale.core.IParent#numElements
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get numElements():int
        {
            COMPILE::SWF
            {
                return numChildren;
            }
            COMPILE::JS
            {
                var children:Array = internalChildren();
                return children.length;
            }
        }
        
        /**
         *  The method called when added to a parent.  This is a good
         *  time to set up beads.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion Class
         *  @royaleignorecoercion Number
         */
        public function addedToParent():void
        {
            var c:Class;
			
            COMPILE::JS
            {
                setClassName(computeFinalClassNames());
                
				if (style)
                    ValuesManager.valuesImpl.applyStyles(this, style);
            }
            
			if (isNaN(_explicitWidth) && isNaN(_percentWidth)) 
            {
				var value:* = ValuesManager.valuesImpl.getValue(this,"width");
				if (value !== undefined) 
                {
					if (value is String)
                    {
                        var s:String = String(value);
                        if (s.indexOf("%") > -1)
        					_percentWidth = Number(s.substring(0, s.length - 1));
                        else
                        {
                            if (s.indexOf("px") !== -1)
                                s = s.substring(0, s.length - 2);
                            _width = _explicitWidth = Number(s);                            
                        }
                    }
					else 
						_width = _explicitWidth = value as Number;
				}
			}
			
			if (isNaN(_explicitHeight) && isNaN(_percentHeight)) 
            {
				value = ValuesManager.valuesImpl.getValue(this,"height");
				if (value !== undefined) 
                {
                    if (value is String)
                    {
    					s = String(value);
                        if (s.indexOf("%") !== -1)
    						_percentHeight = Number(s.substring(0, s.length - 1));
                        else
                        {
                            if (s.indexOf("px") !== -1)
                                s = s.substring(0, s.length - 2);
                            _height = _explicitHeight = Number(s);
                        }
					} 
                    else
						_height = _explicitHeight = value as Number;
				}
			}
            
            for each (var bead:IBead in beads)
                addBead(bead);
                
			loadBeadFromValuesManager(IBeadModel, "iBeadModel", this);
            loadBeadFromValuesManager(IBeadView, "iBeadView", this);
			loadBeadFromValuesManager(IBeadController, "iBeadController", this);
            dispatchEvent(new Event("beadsAdded"));
        }

        private var _measurementBead:IMeasurementBead;
        /**
         *  A measurement bead, if one exists.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get measurementBead() : IMeasurementBead
		{
            if(!_measurementBead)
            {
			    _measurementBead = loadBeadFromValuesManager(IMeasurementBead, "iMeasurementBead", this) as IMeasurementBead;
            }
            return _measurementBead;
		}
        
        COMPILE::SWF
        private var _stageProxy:StageProxy;
        
        /**
         *  @copy org.apache.royale.core.IUIBase#topMostEventDispatcher
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		public function get topMostEventDispatcher():IEventDispatcher
        {
            COMPILE::SWF
            {
                if (!_stageProxy)
                {
                    _stageProxy = new StageProxy(stage);
                    _stageProxy.addEventListener("removedFromStage", stageProxy_removedFromStageHandler);
                }
                
                return _stageProxy;
            }
            COMPILE::JS
            {
                var e:WrappedHTMLElement = document.body as WrappedHTMLElement;
                return e.royale_wrapper as IEventDispatcher;
            }
        }
        
        COMPILE::SWF
        private function stageProxy_removedFromStageHandler(event:Event):void
        {
            _stageProxy = null;
        }
        
        /**
         * Rebroadcast an event from a sub component from the component.
         */
        protected function repeaterListener(event:Event):void
        {
            dispatchEvent(event);
        }
        
        /**
         * The HTMLElement used to position the component.
         */
        COMPILE::JS
        public function get positioner():WrappedHTMLElement
        {
            return element;
        }
        
        /**
         * @private
         */
        COMPILE::JS
        public function set positioner(value:WrappedHTMLElement):void
        {
            element = value;
        }
        
        /**
         * @return The actual element to be parented.
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'div');
            positioner.style.display = 'block';
            //positioner.style.position = 'relative';
            return element;
        }
        
        
        /**
         * The HTMLElement used to position the component.
         * @royaleignorecoercion String
         */
        COMPILE::JS
        public function get alpha():Number 
        {
            var stralpha:String = positioner.style.opacity as String;
            var alpha:Number = parseFloat(stralpha);
            return alpha;
        }
        
        COMPILE::JS
        public function set alpha(value:Number):void
        {
            positioner.style.opacity = value;
        }

        /**
         * @param value The event containing new style properties.
         */
        COMPILE::JS
        protected function styleChangeHandler(value:ValueChangeEvent):void
        {
            var newStyle:Object = {};
            newStyle[value.propertyName] = value.newValue;
            ValuesManager.valuesImpl.applyStyles(this, newStyle);
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion org.apache.royale.core.IParent
         */
        COMPILE::JS
        public function get parent():IParent
        {
            var p:WrappedHTMLElement = this.positioner.parentNode as WrappedHTMLElement;
            var wrapper:IParent = p ? p.royale_wrapper as IParent : null;
            return wrapper;
        }
        
        COMPILE::SWF
        {
        [SWFOverride(returns="flash.display.DisplayObjectContainer")]
        override public function get parent():IParent
        {
            return super.parent as IParent;
        }
        }
        
		COMPILE::SWF
		public function get transformElement():IRoyaleElement
		{
			return this;
		}
		
		COMPILE::JS
		public function get transformElement():WrappedHTMLElement
		{
			return element;
		}
        
        COMPILE::SWF
        {
        [SWFOverride(params="flash.events.Event", altparams="org.apache.royale.events.Event:org.apache.royale.events.MouseEvent")]
        override public function dispatchEvent(event:org.apache.royale.events.Event):Boolean
        {
            return super.dispatchEvent(event);
        }
        }

	}
}
