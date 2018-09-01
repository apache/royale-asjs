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
	import org.apache.royale.core.IDateChooserModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.Table;
	import org.apache.royale.jewel.beads.views.DateChooserView;
	import org.apache.royale.jewel.beads.views.DateFieldView;
	
	/**
	 * The DateFieldMouseController class is responsible for monitoring
	 * the mouse events on the elements of the DateField. A click on the
	 * DateField's menu button triggers the pop-up, for example.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DateFieldMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DateFieldMouseController()
		{
		}
		
		private var viewBead:DateFieldView;
		private var daysTable:Table;
		private var model:IDateChooserModel;

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			model = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;

			viewBead = _strand.getBeadByType(DateFieldView) as DateFieldView;			
			IEventDispatcher(viewBead.menuButton).addEventListener(MouseEvent.CLICK, clickHandler);

			viewBead.textInput.addEventListener(Event.CHANGE, inputSelectionChangeHandler);
		}
		
		/**
		 * @private
		 */
		private function clickHandler(event:MouseEvent):void
		{
            event.stopImmediatePropagation();
            
			viewBead.popUpVisible = true;
			IEventDispatcher(viewBead.popUp).addEventListener(Event.CHANGE, changeHandler);
            // removeDismissHandler();
            
            // use a timer to delay the installation of the event handler, otherwise
            // the event handler is called immediately and will dismiss the popup.
            // var t:Timer = new Timer(0.25, 1);
            // t.addEventListener("timer", addDismissHandler);
            // t.start();

			// viewBead.popUp is DateChooser that fills 100% of browser windew-> We want Table inside
			daysTable = (viewBead.popUp.getBeadByType(DateChooserView) as DateChooserView).daysTable;

			IEventDispatcher(daysTable).addEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IUIBase(viewBead.popUp).addEventListener(MouseEvent.MOUSE_DOWN, removePopUpWhenClickOutside);
        }

		protected function handleControlMouseDown(event:MouseEvent):void
		{			
			event.stopImmediatePropagation();
		}
        
		protected function removePopUpWhenClickOutside(event:MouseEvent = null):void
		{
			IEventDispatcher(daysTable).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IUIBase(viewBead.popUp).removeEventListener(MouseEvent.MOUSE_DOWN, removePopUpWhenClickOutside);
			IEventDispatcher(viewBead.popUp).removeEventListener(Event.CHANGE, changeHandler);
			viewBead.popUpVisible = false;
		}

        /**
         * @private
         */
        // private function addDismissHandler(event:Event):void
        // {
        //     var host:UIBase = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
        //     if (host) {
        //         host.addEventListener(MouseEvent.CLICK, dismissHandler);
        //     }
        // }
        
        /**
         * @private
         */
        // private function removeDismissHandler():void
        // {
        //     var host:UIBase = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
        //     if (host) {
        //         host.removeEventListener(MouseEvent.CLICK, dismissHandler);
        //     }
		// }
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
			event.stopImmediatePropagation();
			IEventDispatcher(daysTable).removeEventListener(MouseEvent.MOUSE_DOWN, handleControlMouseDown);
			IUIBase(viewBead.popUp).removeEventListener(MouseEvent.MOUSE_DOWN, removePopUpWhenClickOutside);
			IEventDispatcher(viewBead.popUp).removeEventListener(Event.CHANGE, changeHandler);
            
			model.selectedDate = IDateChooserModel(viewBead.popUp.getBeadByType(IDateChooserModel)).selectedDate;

			viewBead.popUpVisible = false;
			IEventDispatcher(_strand).dispatchEvent(new Event(Event.CHANGE));

            // removeDismissHandler();
		}

		private function isValidDate(d:*):Boolean
		{
			return (d is Date) && !isNaN(d);
		}

		/**
		 * @private
		 */
		private function inputSelectionChangeHandler(event:Event):void
		{
			var len:int = viewBead.textInput.text.length;
			if(len == 10)
			{
				var date:Date = new Date(viewBead.textInput.text);
				model.selectedDate = isValidDate(date) ? date : null;
			}
		}
        
        /**
         * @private
         */
        // private function dismissHandler(event:MouseEvent):void
        // {
        //     var popup:IUIBase = IUIBase(viewBead.popUp);
            
        //     COMPILE::SWF {
        //         var before:IUIBase = event.targetBeforeBubbling["royale_wrapper"] as IUIBase;
        //         if (before) {
        //             while (before != null) {
        //                 if (before == popup) return;
        //                 before = before.parent as IUIBase;
        //             }
        //         }
        //     }

		// 	COMPILE::JS {
		// 		var before:IUIBase = event.target as IUIBase;
		// 		if (before) {
		// 			while (before != null) {
		// 				if (before == popup) return;
		// 				before = before.parent as IUIBase;
		// 			}
		// 		}
		// 	}
			
		// 	viewBead.popUpVisible = false;
        //     // removeDismissHandler();
        // }
	}
}
