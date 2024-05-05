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

package mx.containers.beads
{

import mx.core.Container;

import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.Event;

	/**
	 *  @private
	 *  The PanelInternalContainer is used to apply a custom view to Panel's internal container.
	 */
	public class PanelInternalContainer extends Container
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function PanelInternalContainer()
		{
			super();
			isPassThru = true;//this is a royale-specific approach, not part of original Flex approach
		}



		/**
		 * PanelView coercion ignore because it is already typed-checked prior, below
		 * @royaleignorecoercion org.apache.royale.events.EventDispatcher
		 */
		override public function addedToParent():void
		{
			EventDispatcher(parent).addEventListener('layoutNeeded', onParentLayout);
			super.addedToParent();
		}

		protected function onParentLayout(event:Event):void{
			//run this internal container layout also
			layoutNeeded();
		}

		override public function get minWidth():Number{
			return parent ? Container(parent).minWidth : 0;
		}
	}

}
