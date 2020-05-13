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
package org.apache.royale.html
{
import org.apache.royale.core.IUIBase;
import org.apache.royale.core.IParent;
import org.apache.royale.utils.UIUtils;

	/**
	 * The CascadingMenuWithOnScreenCheck adjusts the position to make sure it is on-screen.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class CascadingMenuWithOnScreenCheck extends CascadingMenu
	{
		override public function show(component:IUIBase, xoffset:Number=0, yoffset:Number=0):void
		{
			var host:IParent = UIUtils.findPopUpHost(component).popUpParent as IParent;
			// save the parent dimensions because when the menu is added it can change the
			// dimensions
			var pw:Number = (host as IUIBase).width;
			var ph:Number = (host as IUIBase).height;
			super.show(component, xoffset, yoffset);
			// check to see if we fit in the parent
			if (y + height > ph)
			{
				y = ph - height;
			}
		}
		
	}
}