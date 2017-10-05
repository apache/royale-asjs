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
	import org.apache.royale.html.TextInput;
	import org.apache.royale.html.accessories.NumericOnlyTextInputBead;
	import org.apache.royale.html.accessories.PasswordInputBead;
	import org.apache.royale.html.accessories.TextPromptBead;
	import org.apache.royale.html.beads.DisableBead;
	
	COMPILE::SWF {
		import org.apache.royale.html.beads.TextInputView;
	}
	
	/**
	 * This class extends the standard TextInput class and adds in
	 * the prompt, password, and numeric accessories (as needed) for
	 * convenience.
	 */
	public class TextInput extends org.apache.royale.html.TextInput
	{
		public function TextInput()
		{
			super();
		}
		
		private var _promptBead:TextPromptBead;
		
		[Bindable("promptChanged")]
		/**
		 * Displays a message to the user when the field is empty.
		 */
		public function get prompt():String
		{
			return _promptBead ? _promptBead.prompt : null;
		}
		
		public function set prompt(value:String):void
		{
			if (_promptBead == null) {
				_promptBead = new TextPromptBead();
				_promptBead.prompt = value ? value : "";
				addBead(_promptBead);
			}
			else {
				_promptBead.prompt = value ? value : "";
			}
			dispatchEvent(new Event("promptChanged"));
		}
		
		private var _passwordBead:PasswordInputBead;
		private var _secure:Boolean = false;
		
		[Bindable("secureChanged")]
		/**
		 * Displays input as * to obsure the content.
		 */
		public function get secure():Boolean
		{
			return _secure;
		}
		public function set secure(value:Boolean):void
		{
			_secure = value;
			
			if (_secure && _passwordBead == null) {
				_passwordBead = new PasswordInputBead();
				addBead(_passwordBead);
			}
			else if (!_secure && _passwordBead != null) {
				removeBead(_passwordBead);
				_passwordBead = null;
			}
			
			dispatchEvent(new Event("secureChanged"));
		}
		
		private var _numericBead:NumericOnlyTextInputBead;
		private var _numeric:Boolean = false;
		
		[Bindable("numericChanged")]
		/**
		 * Allows only numeric values to be entered.
		 */
		public function get numeric():Boolean
		{
			return _numeric;
		}
		public function set numeric(value:Boolean):void
		{
			_numeric = value;
			
			if (_numeric && _numericBead == null) {
				_numericBead = new NumericOnlyTextInputBead();
				addBead(_numericBead);
			}
			else if (!_numeric && _numericBead != null) {
				removeBead(_numericBead);
				_numericBead = null;
			}
			
			dispatchEvent(new Event("numericChanged"));
		}
		
		private var _disableBead:DisableBead;
		private var _enabled:Boolean = true;
		
		[Bindable("enabledChanged")]
		/**
		 * Can enable or disable interaction with the control.
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			if (_disableBead == null) {
				_disableBead = new DisableBead();
				addBead(_disableBead);
			}
			
			_disableBead.disabled = !value;
				
			COMPILE::SWF {
				var textView:TextInputView = view as TextInputView;
				textView.textField.mouseEnabled = _enabled;
			}
			
			dispatchEvent(new Event("enabledChanged"));
		}
	}
}
