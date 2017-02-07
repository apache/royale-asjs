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
package org.apache.flex.express
{
	import org.apache.flex.events.Event;
	import org.apache.flex.html.TextButton;
	import org.apache.flex.html.beads.DisableBead;

	/**
	 * This class extends Container and adds the HorizontalLayout
	 * bead for convenience.
	 */
	public class TextButton extends org.apache.flex.html.TextButton
	{
		public function TextButton()
		{
			super();
		}
		
		private var _disableBead:DisableBead;
		private var _enabled:Boolean = true;
		
		[Bindable("enabledChanged")]
		/**
		 * Can enable or disable interaction with the control.
		 */
		COMPILE::JS
		public function get enabled():Boolean
		{
			return _enabled;
		}
		COMPILE::JS
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			if (_disableBead == null) {
				_disableBead = new DisableBead();
				addBead(_disableBead);
			}
			
			_disableBead.disabled = !value;
				
			dispatchEvent(new Event("enabledChanged"));
		}
		
		[Bindable("enabledChanged")]
		/**
		 * Can enable or disable interaction with the control.
		 */
		COMPILE::SWF
		override public function get enabled():Boolean
		{
			return _enabled;
		}
		COMPILE::SWF
		override public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			if (_disableBead == null) {
				_disableBead = new DisableBead();
				addBead(_disableBead);
			}
			
			_disableBead.disabled = !value;
				
			dispatchEvent(new Event("enabledChanged"));
		}

	}
}