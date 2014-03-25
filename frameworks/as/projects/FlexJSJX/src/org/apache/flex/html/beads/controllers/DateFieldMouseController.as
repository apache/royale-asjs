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
package org.apache.flex.html.beads.controllers
{	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IDateChooserModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.DateFieldView;
	
	/**
	 * The DateFieldMouseController class is responsible for monitoring
	 * the mouse events on the elements of the DateField. A click on the
	 * DateField's menu button triggers the pop-up, for example.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DateFieldMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DateFieldMouseController()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var viewBead:DateFieldView = _strand.getBeadByType(DateFieldView) as DateFieldView;			
			IEventDispatcher(viewBead.menuButton).addEventListener("click", clickHandler);
		}
		
		/**
		 * @private
		 */
		private function clickHandler(event:Event):void
		{
			var viewBead:DateFieldView = _strand.getBeadByType(DateFieldView) as DateFieldView;
			viewBead.popUpVisible = true;
			UIBase(viewBead.popUp).x = UIBase(_strand).x + UIBase(_strand).width - 20;
			UIBase(viewBead.popUp).y = UIBase(_strand).y + UIBase(_strand).height;			
			IEventDispatcher(viewBead.popUp).addEventListener("change", changeHandler);
		}
		
		/**
		 * @private
		 */
		private function changeHandler(event:Event):void
		{
			var viewBead:DateFieldView = _strand.getBeadByType(DateFieldView) as DateFieldView;
			
			var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
			model.selectedDate = IDateChooserModel(viewBead.popUp.getBeadByType(IDateChooserModel)).selectedDate;

			viewBead.popUpVisible = false;
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
		}
	}
}
