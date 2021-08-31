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
package org.apache.royale.html.beads
{
	import org.apache.royale.utils.callLater;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.beads.IComboBoxView;
	
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
	public class HideComboPopupOnMouseDownBead implements IBead
	{
		public function HideComboPopupOnMouseDownBead()
		{
		}
		
		protected var _strand:IStrand;
		
		protected var viewBead:IComboBoxView;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.html.beads.IComboBoxView
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			viewBead = _strand.getBeadByType(IComboBoxView) as IComboBoxView;
			if (viewBead) {
				finishSetup(null);
			} else {
				IEventDispatcher(_strand).addEventListener("viewChanged", finishSetup);
			}
		}
		/**
		 * @royaleignorecoercion org.apache.royale.html.beads.IComboBoxView
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function finishSetup(event:Event):void
		{
			if (viewBead == null) {
				viewBead = loadBeadFromValuesManager(IComboBoxView, "iBeadView", _strand) as IComboBoxView;
			}
			IEventDispatcher(viewBead.popUp).addEventListener("show", handlePopupShow);
			IEventDispatcher(viewBead.popUp).addEventListener("hide", handlePopupHide);
		}
		
		protected function handleControlMouseDown(event:MouseEvent):void
		{			
			event.stopImmediatePropagation();
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handlePopupShow(event:Event):void
		{
			var popup:IUIBase = viewBead.popUp as IUIBase;
			popup.addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IEventDispatcher(_strand).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			callLater(function():void {
				popup.topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
			});
		}
		
		protected function handleTopMostEventDispatcherMouseDown(event:MouseEvent):void
		{
			viewBead.popUpVisible = false;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handlePopupHide(event:Event):void
		{
			IEventDispatcher(viewBead.popUp).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IEventDispatcher(_strand).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IUIBase(viewBead.popUp).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
		}
	}
}
