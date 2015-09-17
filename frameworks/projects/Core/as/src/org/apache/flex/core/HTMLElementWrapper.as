package org.apache.flex.core
{
    COMPILE::JS
    {
        import org.apache.flex.events.BrowserEvent;
        import org.apache.flex.events.EventDispatcher;
		import goog.events;
    }

    [ExcludeClass]
    COMPILE::AS3
    public class HTMLElementWrapper {}

	COMPILE::JS
	public class HTMLElementWrapper extends EventDispatcher implements IStrand
	{

		//--------------------------------------
		//   Static Property
		//--------------------------------------

		static public var googFireListener:Function;

        /**
         * The properties that triggers the static initializer
         */
		static public var installedOverride:Boolean = installOverride();

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
			e.wrappedEvent = eventObject.wrappedEvent;
			return HTMLElementWrapper.googFireListener(listener, e);
		}

        /**
         * Static initializer
         */
		static public function installOverride():Boolean
		{
			HTMLElementWrapper.googFireListener = events.fireListener;
			events.fireListener = HTMLElementWrapper.fireListenerOverride;
			return true;
		}

		//--------------------------------------
		//   Property
		//--------------------------------------

		public var element:EventTarget;
		public var model:IBead;

		protected var beads:Array;
		protected var internalDisplay:String = 'inline';

		//--------------------------------------
		//   Function
		//--------------------------------------

		public function get MXMLDescriptor():Array
		{
			return null;
		}

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
				model = bead;
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
	}
}
