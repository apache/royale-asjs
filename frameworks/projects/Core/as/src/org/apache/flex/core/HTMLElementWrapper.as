package org.apache.flex.core
{
    COMPILE::AS3
    {
        import flash.display.Sprite;
    }
        
    COMPILE::JS
    {
        import window.Event;
        import org.apache.flex.events.Event;        
        import org.apache.flex.events.BrowserEvent;
        import org.apache.flex.events.ElementEvents;
        import org.apache.flex.events.EventDispatcher;
        import goog.events;
        import goog.events.EventTarget;
    }

    COMPILE::AS3
    public class HTMLElementWrapper extends Sprite
    {
        
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
        
		private var _model:IBeadModel;
        
        public function get model():Object
        {
            return IBeadModel(_model);
        }
        
        public function set model(value:Object):void
        {
            if (_model != value)
            {
                addBead(value as IBead);
                dispatchEvent(new org.apache.flex.events.Event("modelChanged"));
            }
        }

		protected var beads:Array;
		protected var internalDisplay:String = 'inline';

		//--------------------------------------
		//   Function
		//--------------------------------------

        /**
         * @param bead The new bead.
         */
		public function addBead(bead:IBead):void
		{
			if (!beads)
			{
				beads = [];
			}

			beads.push(bead);

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

            if (!beads) return null;
            
			n = beads.length;

			for (i = 0; i < n; i++)
			{
				bead = beads[i];

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

			n = beads.length;

			for (i = 0; i < n; i++)
			{
				value = beads[i];

				if (bead === value)
				{
					beads.splice(i, 1);

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
