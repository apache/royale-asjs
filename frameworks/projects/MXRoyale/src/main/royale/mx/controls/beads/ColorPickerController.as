
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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IComboBoxView;
	import org.apache.royale.html.beads.controllers.ComboBoxController;
	import org.apache.royale.events.MouseEvent;
	import mx.core.IUIComponent;
	
	/**
	 *  The ColorPickerView class creates the visual elements of the org.apache.royale.html.ColorPicker 
	 *  component. The job of the view bead is to put together the parts of the ComboBox such as the color container
	 *  and org.apache.royale.html.Button to trigger the pop-up.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	public class ColorPickerController extends ComboBoxController
	{

		override protected function finishSetup(event:Event):void
		{
			super.finishSetup(event);
			if (viewBead == null) {
				viewBead = _strand.getBeadByType(org.apache.royale.html.beads.IComboBoxView) as org.apache.royale.html.beads.IComboBoxView;
			}
			(viewBead.popupButton as IEventDispatcher).addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			(viewBead.popupButton as IEventDispatcher).addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			(viewBead.popupButton as IEventDispatcher).addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleMouseUp(event:MouseEvent):void
		{			
			(event.target as IUIComponent).name = "upSkin";
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleMouseDown(event:MouseEvent):void
		{			
			(event.target as IUIComponent).name = "downSkin";
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleMouseOver(event:MouseEvent):void
		{			
			(event.target as IUIComponent).name = "overSkin";
		}
	}
}