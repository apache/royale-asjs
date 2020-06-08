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
package mx.controls.beads
{
	import org.apache.royale.utils.callLater;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import mx.core.FlexGlobals;
	import org.apache.royale.html.beads.HideComboPopupOnMouseDownBead;
	
	/**
	 *  The HideComboPopupOnMouseDownBead can be used with ComboBox to make sure mouse down events
	 *  close an open popup. For this bead to work the application needs to be sized to the
	 *  window size. See org.apache.royale.core.BrowserResizeListener or BrowserResizeApplicationListener for a way to achieve this.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 9.3
	 */
	public class HideComboPopupOnMouseDownBead extends org.apache.royale.html.beads.HideComboPopupOnMouseDownBead
	{
		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handlePopupShow(event:Event):void
		{
			IEventDispatcher(viewBead.popUp).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			callLater(function():void {
				(FlexGlobals.topLevelApplication as IEventDispatcher).addEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
			});
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function handlePopupHide(event:Event):void
		{
			IEventDispatcher(viewBead.popUp).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IEventDispatcher(_strand).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
            (FlexGlobals.topLevelApplication as IEventDispatcher).removeEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
		}
	}
}
