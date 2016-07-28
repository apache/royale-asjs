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
    COMPILE::SWF
    {
        import flash.display.DisplayObject;
        import flash.display.Sprite;
    }
        
    COMPILE::JS
    {
        import window.Event;
        import org.apache.flex.events.BrowserEvent;
        import org.apache.flex.events.ElementEvents;
        import goog.events;
        import goog.events.EventTarget;
    }
    import org.apache.flex.events.Event;        
    import org.apache.flex.events.EventDispatcher;

    COMPILE::SWF
    public class HTMLElementWrapper extends EventDispatcher
    {
        public function HTMLElementWrapper()
        {
            _sprite = new Sprite();
        }

        private var _sprite:Sprite;
        
        public function get $sprite():Sprite
        {
            return _sprite;
        }
        
        public function set $sprite(value:Sprite):void
        {
            _sprite = value;
        }

        public function get $displayObject():DisplayObject
        {
            return _sprite;
        }

        protected var _elements:Array;

        /**
         * "abstract" method so we can override in JS
         * @param bead The new bead.
         */
        public function addBead(bead:IBead):void
        {            
        }

        private var _parent:IUIBase;
        public function get parent():IUIBase
        {
            return _parent;
        }
        public function set parent(val:IUIBase):void
        {
            _parent = val;
        }

        public function get width():Number
        {
            return _sprite.width;
        }

        public function set width(value:Number):void
        {
            _sprite.width = value;
        }

        public function get height():Number
        {
            return _sprite.height;
        }

        public function set height(value:Number):void
        {
            _sprite.height = value;
        }

        public function get x():Number
        {
            return _sprite.x;
        }

        public function set x(value:Number):void
        {
            _sprite.x = value;
        }

        public function get y():Number
        {
            return _sprite.y;
        }

        public function set y(value:Number):void
        {
            _sprite.y = value;
        }        

        public function get visible():Boolean
        {
            return _sprite.visible;
        }

        public function set visible(value:Boolean):void
        {
            _sprite.visible = value;
        }        

        public function get alpha():Number
        {
            return _sprite.alpha;
        }

        public function set alpha(value:Number):void
        {
            _sprite.alpha = value;
        }        

    }
    
	COMPILE::JS
	public class HTMLElementWrapper extends EventDispatcher implements IStrand
	{

		//--------------------------------------
		//   Static Function
		//--------------------------------------

        /**
         * @param listener The listener object to call {goog.events.Listener}.
         * @param eventObject The event object to pass to the listener.
         * @return Result of listener.
         */
		static public function fireListenerOverride(listener:Object, eventObject:BrowserEvent):Boolean
		{
			var e:BrowserEvent = new BrowserEvent();
			e.wrappedEvent = eventObject;
			return HTMLElementWrapper.googFireListener(listener, e);
		}

        /**
         * Static initializer
         */
		static public function installOverride():Boolean
		{
			HTMLElementWrapper.googFireListener = goog.events.fireListener;
			goog.events.fireListener = HTMLElementWrapper.fireListenerOverride;
			return true;
		}

        //--------------------------------------
        //   Static Property
        //--------------------------------------
        
        static public var googFireListener:Function;
        
        /**
         * The properties that triggers the static initializer.
         * Note, in JS, this property has to be declared
         * after the installOverride.
         */
        static public var installedOverride:Boolean = installOverride();
        
		//--------------------------------------
		//   Property
		//--------------------------------------

		private var _element:WrappedHTMLElement;
        
        public function get element():WrappedHTMLElement
        {
            return _element;
        }
        
        public function set element(value:WrappedHTMLElement):void
        {
            _element = value;
        }
        
        /**
         * allow access from overrides
         */
		protected var _model:IBeadModel;
        
        /**
         * @flexjsignorecoercion Class 
         * @flexjsignorecoercion org.apache.flex.core.IBeadModel 
         */
        public function get model():Object
        {
            if (_model == null) 
            {
                // addbead will set _model
                var m:Class = org.apache.flex.core.ValuesManager.valuesImpl.
                        getValue(this, 'iBeadModel') as Class;
                var b:IBeadModel = new m() as IBeadModel;
                addBead(b);
            }
            return _model;
        }
        
        public function set model(value:Object):void
        {
            if (_model != value)
            {
                addBead(value as IBead);
                dispatchEvent(new org.apache.flex.events.Event("modelChanged"));
            }
        }

		protected var _beads:Vector.<IBead>;
        
		//--------------------------------------
		//   Function
		//--------------------------------------

        /**
         * @param bead The new bead.
         */
		public function addBead(bead:IBead):void
		{
			if (!_beads)
			{
				_beads = new Vector.<IBead>();
			}

			_beads.push(bead);

			if (bead is IBeadModel)
			{
				_model = bead as IBeadModel;
			}

			bead.strand = this;
		}

        /**
         * @param classOrInterface The requested bead type.
         * @return The bead.
         */
		public function getBeadByType(classOrInterface:Class):IBead
		{
			var bead:IBead, i:uint, n:uint;

            if (!_beads) return null;
            
			n = _beads.length;

			for (i = 0; i < n; i++)
			{
				bead = _beads[i];

				if (bead is classOrInterface)
				{
					return bead;
				}
			}

			return null;
		}

		/**
		 * @param bead The bead to remove.
		 * @return The bead.
		 */
		public function removeBead(bead:IBead):IBead
		{
			var i:uint, n:uint, value:Object;

			n = _beads.length;

			for (i = 0; i < n; i++)
			{
				value = _beads[i];

				if (bead === value)
				{
					_beads.splice(i, 1);

					return bead;
				}
			}

			return null;
		}
        
        override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
        {
            var source:Object = getActualDispatcher_(type);
            goog.events.listen(source, type, handler);
        }
        
        override public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
        {
            var source:Object = getActualDispatcher_(type);
            goog.events.unlisten(source, type, handler);
        }
        
        private function getActualDispatcher_(type:String):Object
        {
            var source:Object = this;
            if (ElementEvents.elementEvents[type]) {
                // mouse and keyboard events also dispatch off the element.
                source = this.element;
            }
            return source;
        }
        
        override public function hasEventListener(type:String):Boolean
        {
            var source:Object = this.getActualDispatcher_(type);
            
            return goog.events.hasListener(source, type);
        }

        override public function dispatchEvent(e:Object):Boolean
        {
            var t:String;
            if (typeof(e) === 'string') {
                t = e as String;
                if (e === 'change')
                    e = new window.Event(t);
            }
            else {
                t = e.type;
                if (ElementEvents.elementEvents[t]) {
                    e = new window.Event(t);
                }
            }
            var source:Object = this.getActualDispatcher_(t);
            if (source == this)
                return super.dispatchEvent(e);
            
            return source.dispatchEvent(e);
        }
	}
}
