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
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.beads.views.DateFieldView;
    import org.apache.royale.utils.Timer;
    import org.apache.royale.utils.UIUtils;
	
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
			IEventDispatcher(viewBead.menuButton).addEventListener("click", clickHandler);

			viewBead.textInput.addEventListener(Event.CHANGE, inputSelectionChangeHandler);
		}
		
		/**
		 * @private
		 */
		private function clickHandler(event:MouseEvent):void
		{
            event.stopImmediatePropagation();
            
			viewBead.popUpVisible = true;
			IEventDispatcher(viewBead.popUp).addEventListener("change", changeHandler);
            removeDismissHandler();
            
            // use a timer to delay the installation of the event handler, otherwise
            // the event handler is called immediately and will dismiss the popup.
            var t:Timer = new Timer(0.25, 1);
            t.addEventListener("timer", addDismissHandler);
            t.start();
        }
        
        /**
         * @private
         */
        private function addDismissHandler(event:Event):void
        {
            var host:UIBase = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
            if (host) {
                host.addEventListener("click", dismissHandler);
            }
        }
        
        /**
         * @private
         */
        private function removeDismissHandler():void
        {
            var host:UIBase = UIUtils.findPopUpHost(_strand as UIBase) as UIBase;
            if (host) {
                host.removeEventListener("click", dismissHandler);
            }
		}
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
            event.stopImmediatePropagation();
            
			model.selectedDate = IDateChooserModel(viewBead.popUp.getBeadByType(IDateChooserModel)).selectedDate;

			viewBead.popUpVisible = false;
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
            
            removeDismissHandler();
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
				model.selectedDate = date;
			}
		}
        
        /**
         * @private
         */
        private function dismissHandler(event:MouseEvent):void
        {
            var popup:IUIBase = IUIBase(viewBead.popUp);
            
            COMPILE::SWF {
                var before:IUIBase = event.targetBeforeBubbling["royale_wrapper"] as IUIBase;
                if (before) {
                    while (before != null) {
                        if (before == popup) return;
                        before = before.parent as IUIBase;
                    }
                }
            }
                COMPILE::JS {
                    var before:IUIBase = event.target as IUIBase;
                    if (before) {
                        while (before != null) {
                            if (before == popup) return;
                            before = before.parent as IUIBase;
                        }
                    }
                }
                
                viewBead.popUpVisible = false;
            removeDismissHandler();
        }
	}
}
