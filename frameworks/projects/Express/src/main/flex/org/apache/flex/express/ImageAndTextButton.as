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
package org.apache.royale.express
{
	import org.apache.royale.events.Event;
	import org.apache.royale.html.ImageAndTextButton;
	import org.apache.royale.html.accessories.ToolTipBead;
	
	/**
	 * This class extends ImageAndTextButton and adds the toolTip bead
	 * as a convenience.
	 */
	public class ImageAndTextButton extends org.apache.royale.html.ImageAndTextButton
	{
		public function ImageAndTextButton()
		{
			super();
		}
		
		private var _toolTipBead:ToolTipBead = null;
		
		[Bindable("toolTipChanged")]
		/**
		 * Displays a hint when the mouse hovers over the button
		 */
		public function get toolTip():String
		{
			if (_toolTipBead) {
				return _toolTipBead.toolTip;
			}
			else {
				return null;
			}
		}
		public function set toolTip(value:String):void
		{
			_toolTipBead = getBeadByType(ToolTipBead) as ToolTipBead;
			
			if (_toolTipBead == null) {
				_toolTipBead = new ToolTipBead();
				addBead(_toolTipBead);
			}
			_toolTipBead.toolTip = value;
			
			dispatchEvent(new Event("toolTipChanged"));
		}
	}
}
