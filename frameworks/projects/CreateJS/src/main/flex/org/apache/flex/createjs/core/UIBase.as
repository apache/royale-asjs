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
package org.apache.flex.createjs.core
{
    import org.apache.flex.core.HTMLElementWrapper;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IStrandWithModel;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStyleableObject;
	import org.apache.flex.core.ILayoutChild;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IBeadController;
    import org.apache.flex.core.IFlexJSElement;
    import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
    COMPILE::JS
    {
        import createjs.Container;
        import createjs.DisplayObject;
        import createjs.Stage;
        import org.apache.flex.core.WrappedHTMLElement;
    }
	
	/**
	 * The CreateJS framework provides its own version of UIBase. CreateJS uses
	 * the HTML 5 &lt;canvas&gt; for its work and does not use the HTML DOM like the
	 * most of FlexJS, so this replacement for UIBase allows the CreateJS wrapper
	 * classes for FlexJS to fit in.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion FlexJS 0.0
	 */
	
	COMPILE::AS3
	public class UIBase extends org.apache.flex.core.UIBase
	{
		// nothing different for the SWF version
	}
        
	COMPILE::JS
	public class UIBase extends HTMLElementWrapper implements IStrandWithModel, IEventDispatcher, IUIBase, IFlexJSElement
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion Class
		 */
		public function UIBase()
		{
			super();
			
			createElement();
		}
		
		private var _view:IBeadView;
		
		/**
		 *  @private
		 *  @flexjsignorecoercion Class
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
		
		private var _style:Object;
		
		/**
		 *  The style object has no meaning for CreateJS, but is provided for
		 *  compatiability and, perhaps in the future, as a way to apply "styles"
		 *  to CreateJS objects.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get style():Object
		{
			return _style;
		}
		
		/**
		 *  Style is not supported for CreateJS.
		 *  @private
		 *  @flexjsignorecoercion String
		 */
		public function set style(value:Object):void
		{
			if (_style != value)
			{
				if (value is String)
				{
					_style = ValuesManager.valuesImpl.parseStyles(value as String);
				}
				else
					_style = value;

				dispatchEvent(new Event("stylesChanged"));
			}
		}
		
		private var _className:String;
		
		/**
		 *  The classname.  Often used for CSS.
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
		 *  Not supported for CreateJS
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
		 *  @copy org.apache.flex.core.Application#beads
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public var beads:Array;
		
		/**
		 *  The method called when added to a parent.  This is a good
		 *  time to set up beads.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion Class
		 *  @flexjsignorecoercion Number
		 */
		public function addedToParent():void
		{
			var c:Class;
			
			if (style)
				ValuesManager.valuesImpl.applyStyles(this, style);
				
			if (isNaN(_explicitWidth) && isNaN(_percentWidth)) 
			{
				var value:* = ValuesManager.valuesImpl.getValue(this,"width");
				if (value !== undefined) 
				{
					if (value is String)
					{
						var s:String = String(value);
						if (s.indexOf("%") != -1)
							_percentWidth = Number(s.substring(0, s.length - 1));
						else
						{
							if (s.indexOf("px") != -1)
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
						if (s.indexOf("%") != -1)
							_percentHeight = Number(s.substring(0, s.length - 1));
						else
						{
							if (s.indexOf("px") != -1)
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
			if (_view == null && getBeadByType(IBeadView) == null) 
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
		 *  @copy org.apache.flex.core.IUIBase#topMostEventDispatcher
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 *  @flexjsignorecoercion org.apache.flex.events.IEventDispatcher
		 */
		public function get topMostEventDispatcher():IEventDispatcher
		{
			var e:WrappedHTMLElement = document.body as WrappedHTMLElement;
			return e.flexjs_wrapper as IEventDispatcher;
		}

        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function addElement(c:Object, dispatchEvent:Boolean = true):void
        {
            (element as Container).addChild(c.element as DisplayObject);
        }
        
        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function addElementAt(c:Object, index:int, dispatchEvent:Boolean = true):void
        {
            (element as Container).addChildAt(c.element as DisplayObject, index);
        }
        
        
        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function getElementIndex(c:Object):int
        {
            return (element as Container).getChildIndex(c.element as DisplayObject);
        }
        

        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function removeElement(c:Object, dispatchEvent:Boolean = true):void
        {
            (element as Container).removeChild(c.element as DisplayObject);
        }
        

        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function getElementAt(index:int):Object
        {
            return (element as Container).getChildAt(index);
        }
        

        /**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function get numElements():int
        {
            return (element as Container).numChildren;
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion createjs.Container
         */
        protected function createElement():WrappedHTMLElement
        {
            element = new createjs.Container() as WrappedHTMLElement;
			element.flexjs_wrapper = this;
            
            positioner = this.element;
            return element;
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
			this._percentWidth = value;
			if (!isNaN(value))
				this._explicitWidth = NaN;
				
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
			this._percentHeight = value;
			if (!isNaN(value))
				this._explicitHeight = NaN;
				
				dispatchEvent(new Event("percentHeightChanged"));
		}
		
		private var _x:Number;
        
        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function get x():Number
        {
            return _x;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function set x(value:Number):void
        {
            var container:DisplayObject = positioner as DisplayObject;
            container.x = value;
			_x = value;
            var stage:Stage = container.getStage();
            if (stage)
                stage.update();
        }
		
		private var _y:Number;

        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function get y():Number
        {
            return _y;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function set y(value:Number):void
        {
            var container:DisplayObject = positioner as DisplayObject;
            container.y = value;
			_y = value;
            var stage:Stage = container.getStage();
            if (stage)
                stage.update();
        }   
		
		private var _width:Number;
        
        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function get width():Number
        {
            return _width;
        }
        
        /**
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function set width(value:Number):void
        {
            var container:DisplayObject = positioner as DisplayObject;
            container.width = value;
			_width = value;
            var stage:Stage = container.getStage();
            if (stage)
                stage.update();
        }
		
		private var _height:Number;

        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function get height():Number
        {
            return _height;
        }
        
        /**
         * @flexjsignorecoercion createjs.Container
         */
        public function set height(value:Number):void
        {
            var container:DisplayObject = positioner as DisplayObject;
            container.height = value;
			_height = value;
            var stage:Stage = container.getStage();
            if (stage)
                stage.update();
        }
		
        /**
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function get visible():Boolean
        {
            return (positioner as DisplayObject).visible;
        }
        
        /**
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function set visible(value:Boolean):void
        {
            var oldValue:Boolean = (positioner as DisplayObject).visible;
            if (value !== oldValue) 
            {
                if (!value) 
                {
                    (positioner as DisplayObject).visible = value;
                    dispatchEvent(new Event('hide'));
                } 
                else 
                {
                    (positioner as DisplayObject).visible = value;
                    dispatchEvent(new Event('show'));
                }
                dispatchEvent(new Event('visibleChanged'));
            }
        }

        /**
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function get alpha():Number 
        {
            return (positioner as DisplayObject).alpha;
        }
        
        /**
         * @flexjsignorecoercion createjs.DisplayObject
         */
        public function set alpha(value:Number):void
        {
            (positioner as DisplayObject).alpha = value;
        }

        private var _positioner:WrappedHTMLElement;
        
        /**
         * The HTMLElement used to position the component.
         */
        public function get positioner():WrappedHTMLElement
        {
            return _positioner;
        }
        
        /**
         * @private
         */
        public function set positioner(value:WrappedHTMLElement):void
        {
            _positioner = value;
        }
		
		/**
         * @flexjsignorecoercion createjs.Container
         * @flexjsignorecoercion createjs.DisplayObject
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function get parent():IUIBase
		{
			var pos:createjs.DisplayObject = this.positioner as createjs.DisplayObject;
			var p:WrappedHTMLElement = pos['parent'] as WrappedHTMLElement;
			var wrapper:IUIBase = p ? p.flexjs_wrapper as IUIBase : null;
			return wrapper;
		}
		
		// CreateJS - specific properties and functions
		
		protected function convertColorToString(value:uint, alpha:Number=1.0):String
		{
			// ideally, for CreateJS, we convert the color value and alpha into the
			// format: "rgba(red,green,blue,alpha)" such as "rgba(255,0,0,1.0)"
			// but for now we'll make it easy
			var color:String = Number(value).toString(16);
			if (color.length == 1) color = '00' + color;
			if (color.length == 2) color = '00' + color;
			if (color.length == 4) color = '00' + color;
			return "#"+color;
		}

	}
}
