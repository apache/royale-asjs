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
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.html.TextInput;
	import org.apache.royale.html.Button;
	import org.apache.royale.html.TextButton;
	import org.apache.royale.html.List;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.beads.IComboBoxView;
	import org.apache.royale.html.util.getLabelFromData;
	
	/**
	 *  The ComboBoxView class creates the visual elements of the org.apache.royale.html.ComboBox 
	 *  component. The job of the view bead is to put together the parts of the ComboBox such as the TextInput
	 *  control and org.apache.royale.html.Button to trigger the pop-up.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ComboBoxView extends BeadViewBase implements IComboBoxView
	{
		public function ComboBoxView()
		{
			super();
		}
		
		private var input:TextInput;
		
		/**
		 *  The TextInput component of the ComboBox.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get textInputField():Object
		{
			return input;
		}
		
		private var button:TextButton;
		
		/**
		 *  The Button component of the ComboBox.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get popupButton():Object
		{
			return button;
		}
		
		protected var list:UIBase;
		
		/**
		 *  The pop-up list component of the ComboBox.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get popUp():Object
		{
			return list;
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var host:UIBase = value as UIBase;
			
			input = new TextInput();
			input.className = "ComboBoxTextInput";			
			
			button = new TextButton();
			button.style = {
				"padding": 0,
				"margin": 0
			};
			button.text = '\u25BC';
			
			if (isNaN(host.width)) input.width = 100;
			
			COMPILE::JS 
			{
				// inner components are absolutely positioned so we want to make sure the host is the offset parent
				if (!host.element.style.position)
				{
					host.element.style.position = "relative";
				}
			}
			host.addElement(input);
			host.addElement(button);
			
			var popUpClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
			list = new popUpClass() as UIBase;
			list.visible = false;
			
			var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
			model.addEventListener("selectedIndexChanged", handleItemChange);
			model.addEventListener("selectedItemChanged", handleItemChange);
			
			IEventDispatcher(_strand).addEventListener("sizeChanged", handleSizeChange);
			
			// set initial value and positions using default sizes
			itemChangeAction();
			sizeChangeAction();
		}
		
		/**
		 *  Returns whether or not the pop-up is visible.
		 * 
		 *  @copy org.apache.royale.html.beads.IComboBoxView#text
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get popUpVisible():Boolean
		{
			if (list) return list.visible;
			else return false;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		public function set popUpVisible(value:Boolean):void
		{
			if (value && !list.visible) {
				var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
				list.model = model;
				list.width = input.width;
				list.height = 200;
				list.visible = true;
				
				var origin:Point = new Point(0, button.y+button.height);
				var relocated:Point = PointUtils.localToGlobal(origin,_strand);
				list.x = relocated.x
				list.y = relocated.y;
				COMPILE::JS {
					list.element.style.position = "absolute";
				}
				
				var popupHost:IPopUpHost = UIUtils.findPopUpHost(_strand as IUIBase);
				popupHost.popUpParent.addElement(list);
			}
			else if (list.visible) {
				UIUtils.removePopUp(list);
				list.visible = false;
			}
		}
		
		/**
		 * @private
		 */
		protected function handleSizeChange(event:Event):void
		{
			sizeChangeAction();
		}
		
		/**
		 * @private
		 */
		protected function handleItemChange(event:Event):void
		{
			itemChangeAction();
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
		 */
		protected function itemChangeAction():void
		{
			var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
			input.text = getLabelFromData(model,model.selectedItem);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		protected function sizeChangeAction():void
		{
			var host:UIBase = UIBase(_strand);
			
			input.x = 0;
			input.y = 0;
			if (host.isWidthSizedToContent()) {
				input.width = 100;
			} else {
				input.width = host.width - 20;
			}
			
			button.x = input.width;
			button.y = 0;
			button.width = 20;
			button.height = input.height;
			
			COMPILE::JS {
				input.element.style.position = "absolute";
				button.element.style.position = "absolute";
			}
				
			if (host.isHeightSizedToContent()) {
				host.height = input.height;
			}
			if (host.isWidthSizedToContent()) {
				host.width = input.width + button.width;
			}
		}
	}
}
