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
        import flash.display.Sprite;
    }
        
    COMPILE::JS
    {
        import org.apache.flex.events.Event;        
        import org.apache.flex.events.BrowserEvent;
        import org.apache.flex.events.IBrowserEvent;
        import org.apache.flex.events.ElementEvents;
        import org.apache.flex.events.EventDispatcher;
        import goog.events;
        import goog.events.EventTarget;
        import org.apache.flex.events.utils.EventUtils;
        import org.apache.flex.events.KeyboardEvent;
        import org.apache.flex.events.MouseEvent;
        import goog.events.BrowserEvent;
        import org.apache.flex.events.utils.KeyboardEventConverter;
        import org.apache.flex.events.utils.MouseEventConverter;
    }

    COMPILE::SWF
    public class HTMLElementWrapper extends Sprite
    {
        /**
         * "abstract" method so we can override in JS
         * @param bead The new bead.
         */
        public function addBead(bead:IBead):void
        {            
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
		static public function fireListenerOverride(listener:Object, eventObject:goog.events.BrowserEvent):Boolean
		{
            var e:IBrowserEvent;
            switch(eventObject["event_"]["constructor"]["name"])
            {
                case "KeyboardEvent":
                    e = KeyboardEventConverter.convert(eventObject["event_"]);
                    break;
                case "MouseEvent":
                    e = MouseEventConverter.convert(eventObject["event_"]);
                    break;
                default:
                    e = new org.apache.flex.events.BrowserEvent();
                    break;
            }

			e.wrapEvent(eventObject);
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
		protected var _model:Object;
        
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
        
        [Bindable("modelChanged")]
        public function set model(value:Object):void
        {
            if (_model != value)
            {
                if (value is IBead)
                    addBead(value as IBead);
                else
                    _model = value;
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
                    bead.strand = null;
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
            var eventType:String = "";
            if (typeof(e) === 'string')
            {
                eventType = e as String;
                if (e === org.apache.flex.events.Event.CHANGE)
                {
                    e = EventUtils.createEvent(eventType, e.bubbles);
                }
            }
            else
            {
                eventType = e.type;
                if (ElementEvents.elementEvents[eventType])
                {
                    e = EventUtils.createEvent(eventType, e.bubbles);
                }
            }
            var source:Object = this.getActualDispatcher_(eventType);
            if (source == this)
            {
                return super.dispatchEvent(e);
            }
            
            return source.dispatchEvent(e);
        }
	}
}
