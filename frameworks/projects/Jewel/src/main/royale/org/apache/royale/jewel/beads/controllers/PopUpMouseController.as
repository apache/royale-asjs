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
package org.apache.royale.jewel.beads.controllers
{	
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.PopUp;
	import org.apache.royale.jewel.beads.views.PopUpView;
	
	/**
	 * The PopUpMouseController class is responsible for monitoring
	 * the mouse events on the elements of the DateField. A click on the
	 * DateField's menu button triggers the pop-up, for example.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class PopUpMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function PopUpMouseController()
		{
		}
		
		private var viewBead:PopUpView;

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			viewBead = _strand.getBeadByType(PopUpView) as PopUpView;			
			IEventDispatcher(_strand).addEventListener("openPopUp", openPopUpHandler);
			IEventDispatcher(_strand).addEventListener("closePopUp", closePopUpHandler);
			IEventDispatcher(_strand).addEventListener("showingPopUp", addContentListeners);
		}
		
		/**
		 * @private
		 */
		private function openPopUpHandler(event:Event):void
		{
			PopUp(_strand).open = true;
            viewBead.popUpVisible = true;
			
			if(!PopUp(_strand).modal)
			{
				IUIBase(viewBead.popUp).addEventListener(MouseEvent.MOUSE_DOWN, closePopUpHandler);
			}
        }
		/**
		 * @private
		 */
		public function addContentListeners(event:Event):void
		{
			if(!PopUp(_strand).modal)
			{
				IEventDispatcher(viewBead.content).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			}
			viewBead.content.addEventListener("closePopUp", closePopUpHandler);
		}
		
		protected function handleControlMouseDown(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
        
		protected function closePopUpHandler(event:Event = null):void
		{
			viewBead.content.removeEventListener("closePopUp", closePopUpHandler);
			if(!PopUp(_strand).modal)
			{
				IEventDispatcher(viewBead.content).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
				IUIBase(viewBead.popUp).removeEventListener(MouseEvent.MOUSE_DOWN, closePopUpHandler);
			}
			PopUp(_strand).open = false;
			viewBead.popUpVisible = false;
		}
	}
}
