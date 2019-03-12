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
	import org.apache.royale.core.IComboBoxModel;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.geom.Point;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;
	
	/**
	 *  The ColorPickerView class creates the visual elements of the org.apache.royale.html.ColorPicker
	 *  component. The job of the view bead is to put together the parts of the ColorPicler such as the TextInput
	 *  control and org.apache.royale.html.Button to trigger the pop-up.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class ColorPickerView extends ComboBoxView
	{
		public function ColorPickerView()
		{
			super();
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IComboBoxModel
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		override public function set popUpVisible(value:Boolean):void
		{
			var list:UIBase = popUp as UIBase;
			var button:UIBase = popupButton as UIBase;
			if (value && !list.visible) {
				var model:IComboBoxModel = _strand.getBeadByType(IComboBoxModel) as IComboBoxModel;
				list.model = model;
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
	}
}
