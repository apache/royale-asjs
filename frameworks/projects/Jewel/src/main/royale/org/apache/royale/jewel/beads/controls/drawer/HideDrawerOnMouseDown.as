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
package org.apache.royale.jewel.beads.controls.drawer
{
	import org.apache.royale.utils.callLater;
    import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.Drawer;
	
	/**
	 *  The HideDrawerOnMouseDown can be used with a Drawer to make sure mouse down events
	 *  close an open drawer. For this bead to work the application needs to be sized to the
	 *  window size. See org.apache.royale.core.BrowserResizeListener or BrowserResizeApplicationListener for a way to achieve this.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class HideDrawerOnMouseDown implements IBead
	{
		public function HideDrawerOnMouseDown()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion HTMLInputElement
		 *  @royaleignorecoercion org.apache.royale.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("openDrawer", handlePopupShow);
			IEventDispatcher(value).addEventListener("closeDrawer", handlePopupHide);
		}
		
		protected function handleControlMouseDown(event:MouseEvent):void
		{			
			event.stopImmediatePropagation();
		}
		
		protected function handlePopupShow(event:Event):void
		{
			IEventDispatcher(event.target).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			callLater(function():void {
				IUIBase(event.target).topMostEventDispatcher.addEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
			});
		}
		
		protected function handleTopMostEventDispatcherMouseDown(event:MouseEvent):void
		{
			(_strand as Drawer).close();
		}
		
		protected function handlePopupHide(event:Event):void
		{
			IEventDispatcher(event.target).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IUIBase(event.target).topMostEventDispatcher.removeEventListener(MouseEvent.MOUSE_DOWN, handleTopMostEventDispatcherMouseDown);
		}
	}
}

