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
package mx.controls.buttonBarClasses
{
	import org.apache.royale.html.beads.ButtonBarView;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	/**
	 *  The ToggleButtonBarView class creates the visual elements of the mx.controls.ToggleButtonBar
	 *  component. It uses lower-level Basic components.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ToggleButtonBarView extends ButtonBarView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ToggleButtonBarView()
		{
			super();
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handleInitComplete(event:Event):void{
			super.handleInitComplete(event);
			if (listModel.selectedIndex > -1) {
				//initialize the selected Button:
				selectionChangeHandler(null);
			}
			//listen for recreation of items, and update selection accordingly
			(_strand as IEventDispatcher).addEventListener('itemsCreated', selectionChangeHandler)
		}

	}
}
