/*
 * Copyright 2010 Swiz Framework Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package org.apache.royale.crux.events
{
    import org.apache.royale.events.Event;
	import org.apache.royale.events.IRoyaleEvent;
    import org.apache.royale.crux.ICrux;

    /**
	 * Dispatched when a Crux instance is created or destroyed.
	 */
	public class CruxEvent extends Event
	{
		/**
		 * Constructor
		 */
		public function CruxEvent( type:String, crux:ICrux = null )
		{
			super( type, true, true );
			this.crux = crux;
		}

		/**
		 * The CruxEvent.CREATED constant defines the value of the type property
		 * of a cruxCreated event object.
		 */
		public static const CREATED:String = "cruxCreated";
		
		/**
		 * The CruxEvent.LOAD_COMPLETE constant defines the value of the type property
		 * of an initial load complete event object.
		 */
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		/**
		 * The CruxEvent.DESTROYED constant defines the value of the type property
		 * of a cruxDestroyed event object.
		 */
		public static const DESTROYED:String = "cruxDestroyed";
		
		/**
		 * The <code>ICrux</code> instance that was created or destroyed.
		 * @royalesuppresspublicvarwarning
		 */
		public var crux:ICrux;
		
		
		/**
		 * @private
		 */
		override public function cloneEvent():IRoyaleEvent
		{
			return new CruxEvent( type, crux );
		}
	}
}
