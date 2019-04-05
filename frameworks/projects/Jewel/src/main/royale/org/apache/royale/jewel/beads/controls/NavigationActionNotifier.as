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
package org.apache.royale.jewel.beads.controls
{	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 *  The NavigationActionNotifier notifies when a control's "change" or "click" event is thrown
	 *  Other application parts can listen for "navigationAction" event to respond accordingly.
	 *  
	 *  This bead should be used with Navigation, TabBar or a Button (that could be located in TobAppBar)
	 *  or any other navigation component that triggers some navigation action
	 * 
	 *  An example of use case is to use with CleanValidationErrors bead
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class NavigationActionNotifier implements IBead
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function NavigationActionNotifier()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
            IEventDispatcher(_strand).addEventListener("change", changeOrClickNotifier);
            IEventDispatcher(_strand).addEventListener("click", changeOrClickNotifier);
		}

		/**
		 * dispatch "navigationAction" event that bubbles all the DOM tree
		 * @param ev 
		 */
        private function changeOrClickNotifier(ev:Event):void
		{
            IEventDispatcher(_strand).dispatchEvent(new Event("navigationAction", true));
        }
	}
}
