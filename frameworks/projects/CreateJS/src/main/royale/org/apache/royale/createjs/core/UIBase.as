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
package org.apache.royale.createjs.core
{
    import org.apache.royale.core.UIHTMLElementWrapper;
    import org.apache.royale.core.IChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.core.IParent;
    import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStyleableObject;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IBeadController;
    import org.apache.royale.core.IRoyaleElement;
    import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.CSSUtils;
	
    COMPILE::JS
    {
        import createjs.Container;
        import createjs.DisplayObject;
        import createjs.Stage;
		import goog.events.EventTarget;
		import org.apache.royale.core.IChild;
        import org.apache.royale.events.EventDispatcher;
        import org.apache.royale.core.WrappedHTMLElement;
    }
	
	/**
	 * The CreateJS framework provides its own version of UIBase. CreateJS uses
	 * the HTML 5 &lt;canvas&gt; for its work and does not use the HTML DOM like the
	 * most of Royale, so this replacement for UIBase allows the CreateJS wrapper
	 * classes for Royale to fit in.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.0
	 */
	
	COMPILE::SWF
	public class UIBase extends org.apache.royale.core.UIBase
	{
		// nothing different for the SWF version
	}
        
	COMPILE::JS
	public class UIBase extends UIHTMLElementWrapper implements IStrandWithModel, IEventDispatcher, IUIBase, IRoyaleElement
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion Class
		 */
		public function UIBase()
		{
			super();
			
			createElement();
		}
		
		private var _view:IBeadView;
		
		/**
		 *  @private
		 *  @royaleignorecoercion Class
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
		
		private var _style:Object;
		
		/**
		 *  The style object has no meaning for CreateJS, but is provided for
		 *  compatiability and, perhaps in the future, as a way to apply "styles"
		 *  to CreateJS objects.
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
		 *  Style is not supported for CreateJS.
		 *  @private
		 *  @royaleignorecoercion String
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
		 *  @productversion Royale 0.0
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

        COMPILE::JS
		/**
		 * @royaleignorecoercion org.apache.royale.core.IChild
		 * @royaleemitcoercion org.apache.royale.events.EventDispatcher
		 */
		override public function getParentEventTarget():goog.events.EventTarget{
			return (this as IChild).parent as EventDispatcher;
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
			var e:WrappedHTMLElement = document.body as WrappedHTMLElement;
			return e.royale_wrapper as IEventDispatcher;
		}

        /**
         * @royaleignorecoercion createjs.Container
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function addElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            (element as Container).addChild(c.element as DisplayObject);
        }
        
        /**
         * @royaleignorecoercion createjs.Container
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
        {
            (element as Container).addChildAt(c.element as DisplayObject, index);
        }
        
        
        /**
         * @royaleignorecoercion createjs.Container
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function getElementIndex(c:IChild):int
        {
            return (element as Container).getChildIndex(c.element as DisplayObject);
        }
        

        /**
         * @royaleignorecoercion createjs.Container
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
            (element as Container).removeChild(c.element as DisplayObject);
        }
        

        /**
         * @royaleignorecoercion createjs.Container
         * @royaleignorecoercion createjs.DisplayObject
         * @royaleignorecoercion org.apache.royale.core.IChild
         */
        public function getElementAt(index:int):IChild
        {
            return (element as Container).getChildAt(index) as IChild;
        }
        

        /**
         * @royaleignorecoercion createjs.Container
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function get numElements():int
        {
            return (element as Container).numChildren;
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion createjs.Container
         */
        protected function createElement():WrappedHTMLElement
        {
            element = new createjs.Container() as WrappedHTMLElement;
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
			this._percentHeight = value;
			if (!isNaN(value))
				this._explicitHeight = NaN;
				
				dispatchEvent(new Event("percentHeightChanged"));
		}
		
		private var _x:Number;
        
        /**
         * @royaleignorecoercion createjs.Container
         */
        public function get x():Number
        {
            return _x;
        }
        
        /**
         * @royaleignorecoercion createjs.Container
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
         * @royaleignorecoercion createjs.Container
         */
        public function get y():Number
        {
            return _y;
        }
        
        /**
         * @royaleignorecoercion createjs.Container
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
         * @royaleignorecoercion createjs.Container
         */
        public function get width():Number
        {
            return _width;
        }
        
        /**
         * @royaleignorecoercion createjs.DisplayObject
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
         * @royaleignorecoercion createjs.Container
         */
        public function get height():Number
        {
            return _height;
        }
        
        /**
         * @royaleignorecoercion createjs.Container
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
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function get visible():Boolean
        {
            return (positioner as DisplayObject).visible;
        }
        
        /**
         * @royaleignorecoercion createjs.DisplayObject
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
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function get alpha():Number 
        {
            return (positioner as DisplayObject).alpha;
        }
        
        /**
         * @royaleignorecoercion createjs.DisplayObject
         */
        public function set alpha(value:Number):void
        {
            (positioner as DisplayObject).alpha = value;
        }

		/**
         * @royaleignorecoercion createjs.Container
         * @royaleignorecoercion createjs.DisplayObject
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function get parent():IParent
		{
			var pos:createjs.DisplayObject = this.positioner as createjs.DisplayObject;
			var p:WrappedHTMLElement = pos['parent'] as WrappedHTMLElement;
			var wrapper:IParent = p ? p.royale_wrapper as IParent : null;
			return wrapper;
		}
		
		// CreateJS - specific properties and functions
		
		protected function convertColorToString(value:uint, alpha:Number=1.0):String
		{
			// ideally, for CreateJS, we convert the color value and alpha into the
			// format: "rgba(red,green,blue,alpha)" such as "rgba(255,0,0,1.0)"
			// but for now we'll make it easy
			if(alpha < 1)
			{
				// we should be doing something else...
				return CSSUtils.attributeFromColor(value);
			}
			return CSSUtils.attributeFromColor(value);
		}

	}
}
