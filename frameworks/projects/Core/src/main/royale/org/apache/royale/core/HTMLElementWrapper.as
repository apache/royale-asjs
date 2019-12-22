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
	import org.apache.royale.events.IEventDispatcher;

    COMPILE::SWF
    {
        import flash.display.Sprite;
        import org.apache.royale.events.Event;
    }
        
    COMPILE::JS
    {
        import org.apache.royale.events.Event;        
        import org.apache.royale.events.BrowserEvent;
        import org.apache.royale.events.IBrowserEvent;
        import org.apache.royale.events.ElementEvents;
        import org.apache.royale.events.EventDispatcher;
        import goog.events;
        import goog.events.BrowserEvent;
        import goog.events.EventTarget;
        import goog.DEBUG;
        import org.apache.royale.events.utils.EventUtils;
    }

    COMPILE::SWF
    public class HTMLElementWrapper extends Sprite implements IStrand, IEventDispatcher
    {
        
        private var _beads:Vector.<IBead>;
    
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
         *  @copy org.apache.royale.core.IStrand#getBeadByType()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @copy org.apache.royale.core.IStrand#removeBead()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         * allow access from overrides
         */
        protected var _model:IBeadModel;
    
        /**
         * @royaleignorecoercion Class
         * @royaleignorecoercion org.apache.royale.core.IBeadModel
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
         * @private
         * @royaleignorecoercion org.apache.royale.core.IBead
         */
        [Bindable("modelChanged")]
        public function set model(value:Object):void
        {
            if (_model != value)
            {
                addBead(value as IBead);
                dispatchEvent(new Event("modelChanged"));
            }
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
         * @royaleignorecoercion org.apache.royale.events.IBrowserEvent
         */
		static public function fireListenerOverride(listener:Object, eventObject:goog.events.BrowserEvent):Boolean
		{
            /**
             * For now we're adding in some just-in-case code to prevent conflicts with ElementWrapper. This needs to be fixed.
             */
            var e:IBrowserEvent;
            if(eventObject is IBrowserEvent){
                e = eventObject as IBrowserEvent
            } else {
                var nativeEvent:Object = eventObject.getBrowserEvent();
                var converter:Object = converterMap[nativeEvent.constructor.name];
                if (converter)
                    e = converter["convert"](nativeEvent,eventObject);
                else
                {
                    e = new org.apache.royale.events.BrowserEvent();
                    e.wrapEvent(eventObject);
                }
            }
			return HTMLElementWrapper.googFireListener(listener, e);
		}
        
        /**
         * @royalesuppresspublicvarwarning
         */
        static public var converterMap:Object = {};

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
        
        /**
         * The original fireListener.
         * 
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
            _element.royale_wrapper = this;
        }
        
        /**
         * allow access from overrides
         */
		protected var _model:IBeadModel;
        
        /**
         * @royaleignorecoercion Class 
         * @royaleignorecoercion org.apache.royale.core.IBeadModel
         */
        public function get model():Object
        {
            if (_model == null) 
            {
                // addbead will set _model
                var m:Class = org.apache.royale.core.ValuesManager.valuesImpl.
                        getValue(this, 'iBeadModel') as Class;
                var b:IBeadModel = new m() as IBeadModel;
                addBead(b);
            }
            return _model;
        }
        
        /**
         * @royaleignorecoercion org.apache.royale.core.IBead
         * @royaleignorecoercion org.apache.royale.core.IBeadModel
         */
        [Bindable("modelChanged")]
        public function set model(value:Object):void
        {
            if (_model != value)
            {
                if (value is IBead)
                    addBead(value as IBead);
                else
                    _model = IBeadModel(value);
                dispatchEvent(new org.apache.royale.events.Event("modelChanged"));
            }
        }
        
		private var _beads:Array;
        
		//--------------------------------------
		//   Function
		//--------------------------------------

        /**
         * @param bead The new bead.
         * @royaleignorecoercion org.apache.royale.core.IBeadModel 
         */
		public function addBead(bead:IBead):void
		{
			if (!_beads)
			{
				_beads = [];
			}
            if (goog.DEBUG && !(bead is IBead)) throw new TypeError('Cannot convert '+bead+' to IBead')
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

        /**
         * @royaleignorecoercion String
         */
        override public function dispatchEvent(e:Object):Boolean
        {
            var eventType:String = "";
            if (typeof(e) === 'string')
            {
                eventType = e as String;
                if (e === org.apache.royale.events.Event.CHANGE)
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
			if (e.bubbles) {
				return dispatchBubblingEvent(source, e);
			}
            if (source == this)
            {
                return super.dispatchEvent(e);
            }
            
            return source.dispatchEvent(e);
        }
		
        /**
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		public function dispatchBubblingEvent(source:Object, e:Object):Boolean
		{
			// build the ancestors tree without setting the actual parentEventTarget
			var ancestorsTree:Array = [];
			var t:IEventDispatcher = source["parent"] as IEventDispatcher;
			while (t != null) {
				ancestorsTree.push(t);
				t = t["parent"] as IEventDispatcher;
			}
			
			return goog.events.EventTarget.dispatchEventInternal_(source, e, ancestorsTree);
		}
	}
}
