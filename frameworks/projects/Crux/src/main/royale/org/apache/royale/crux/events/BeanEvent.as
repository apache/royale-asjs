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

    /**
	 * Dispatched when a Bean is added to or removed from a
	 * <code>BeanProvider</code>.
	 *
	 * @see org.apache.royale.crux.BeanProvider
	 */
	public class BeanEvent extends Event
	{
		/**
		 * Constructor
		 */
		public function BeanEvent( type:String, source:* = null, beanName:String = null )
		{
			super( type, true, true );
			
			this.source = source;
			this.beanName = beanName;
		}
        
		public static const ADD_BEAN:String = "addBean";
		public static const SET_UP_BEAN:String = "setUpBean";
		public static const TEAR_DOWN_BEAN:String = "tearDownBean";
		public static const REMOVE_BEAN:String = "removeBean";
		
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var source:*;
		
		/**
		 * @royalesuppresspublicvarwarning
		 */
		public var beanName:String;
		
		
		/**
		 * @private
		 */
		override public function cloneEvent():IRoyaleEvent
		{
			return new BeanEvent( type, source );
		}
		
	}
}
