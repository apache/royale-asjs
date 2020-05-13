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

package mx.controls.menuClasses
{
import org.apache.royale.core.IUIBase;
import org.apache.royale.html.CascadingMenu;
import org.apache.royale.utils.UIUtils;
import mx.managers.SystemManager;

	/**
	 *  The CascadingMenuWithOnScreenCheck handles cascading menus in MXRoyale
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */

	public class CascadingMenuWithOnScreenCheck extends CascadingMenu
	{
		public function CascadingMenuWithOnScreenCheck()
		{
			super();
		}

		override public function show(component:IUIBase, xoffset:Number=0, yoffset:Number=0):void
		{
			var host:SystemManager = UIUtils.findPopUpHost(component).popUpParent as SystemManager;
			// save the parent dimensions because when the menu is added it can change the
			// dimensions
			var pw:Number = host.screen.width;
			var ph:Number = host.screen.height;
			super.show(component, xoffset, yoffset);
			// check to see if we fit in the parent
			if (y + height > ph)
			{
				y = ph - height;
			}
		}
	}

}
