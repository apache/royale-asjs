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
    COMPILE::JS
    {
        import org.apache.royale.events.utils.EventUtils;
        import org.apache.royale.events.BrowserEvent;
        import org.apache.royale.events.IBrowserEvent
        import goog.events.BrowserEvent;
        import org.apache.royale.events.ElementEvents;
        import goog.events;
        import goog.events.EventTarget;
        import goog.DEBUG;
    }
    COMPILE::SWF
    {
        import flash.events.Event;
        import flash.events.IEventDispatcher;
        import org.apache.royale.events.ElementEvents;
        import org.apache.royale.events.IRoyaleEvent;
    }
    
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;

    COMPILE::SWF
    public class ElementWrapper extends EventDispatcher implements IStrand
    {
        public function ElementWrapper()
        {
        }

        //--------------------------------------
        //   Property
        //--------------------------------------
        
        protected var _element:IRoyaleElement;
        
        public function get element():IRoyaleElement
        {
            return _element;
        }
        
        public function set element(value:IRoyaleElement):void
        {
            _element = value;
            _element.royale_wrapper = this;
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
        
        override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, priority:int = 0, weak:Boolean = false):void
        {
            var source:IEventDispatcher = getActualDispatcher_(type) as IEventDispatcher;
            if (source != this)
                source.addEventListener(type, forwarder, opt_capture);
            
            super.addEventListener(type, handler, opt_capture);
        }
        
        override public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false):void
        {
            var source:IEventDispatcher = getActualDispatcher_(type) as IEventDispatcher;
            if (source != this)
                source.removeEventListener(type, handler, opt_capture);
            
            super.removeEventListener(type, handler, opt_capture);
        }
        
        private function getActualDispatcher_(type:String):IEventDispatcher
        {
            var source:IEventDispatcher = this;
            if (ElementEvents.elementEvents[type]) {
                // mouse and keyboard events also dispatch off the element.
                source = this.element as IEventDispatcher;
            }
            return source;
        }
        
        private function forwarder(event:flash.events.Event):void
        {
            if (event is IRoyaleEvent)
                event = IRoyaleEvent(event).cloneEvent() as flash.events.Event;
            dispatchEvent(event);
        }
    }
    
	COMPILE::JS
	public class ElementWrapper extends EventDispatcher implements IStrand
	{

        /**
         * @royalesuppresspublicvarwarning
         */
        static public var converterMap:Object = {};

		//--------------------------------------
		//   Static Function
		//--------------------------------------

        /**
         * @param listener The listener object to call {goog.events.Listener}.
         * @param eventObject The event object to pass to the listener.
         * @return Result of listener.
         * @royaleignorecoercion org.apache.royale.events.IBrowserEvent
         */
		static private function fireListenerOverride(listener:Object, eventObject:goog.events.BrowserEvent):Boolean
		{
            var e:IBrowserEvent;
            var nativeEvent:Object = eventObject.getBrowserEvent();
            var converter:Function = converterMap[nativeEvent.constructor.name];
            if (converter)
                e = converter(nativeEvent,eventObject);
            else
            {
                e = new org.apache.royale.events.BrowserEvent();
                e.wrapEvent(eventObject);
            }
			return ElementWrapper.googFireListener(listener, e);
		}

        /**
         * Static initializer
         */
		static private function installOverride():Boolean
		{
			ElementWrapper.googFireListener = goog.events.fireListener;
			goog.events.fireListener = ElementWrapper.fireListenerOverride;
			return true;
		}

        //--------------------------------------
        //   Static Property
        //--------------------------------------
        
        /**
         *  @royalesuppresspublicvarwarning
         */
        static public var googFireListener:Function;
        
        /**
         * The properties that triggers the static initializer.
         * Note, in JS, this property has to be declared
         * after the installOverride.
         *
         *  @royalesuppresspublicvarwarning
         */
        static public var __:Boolean = installOverride();
        
		//--------------------------------------
		//   Property
		//--------------------------------------

        /**
         * An optimization to skip the getter of the element property
         */
		protected var _element:WrappedHTMLElement;
        
        public function get element():WrappedHTMLElement
        {
            return _element;
        }
        
        public function set element(value:WrappedHTMLElement):void
        {
            _element = value;
            _element.royale_wrapper = this;
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
            if (goog.DEBUG && !(bead is IBead)) throw new TypeError('Cannot convert '+bead+' to IBead');
			_beads.push(bead);
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
            goog.events.listen(source, type, handler, opt_capture ? { capture: true } : null);
        }
        
        override public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
        {
            var source:Object = getActualDispatcher_(type);
            goog.events.unlisten(source, type, handler, opt_capture ? { capture: true } : null);
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
        /**
         * @royaleignorecoercion String
         */
        override public function dispatchEvent(e:Object):Boolean
        {
            var eventType:String = "";
            if (typeof(e) == 'string')
            {
                eventType = e as String;
                if (e == "change")
                {
                    e = EventUtils.createEvent(eventType, e["bubbles"]);
                }
            }
            else
            {
                eventType = e.type;
                if (ElementEvents.elementEvents[eventType])
                {
                    e = EventUtils.createEvent(eventType, e["bubbles"]);
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
