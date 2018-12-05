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
package org.apache.royale.jewel.beads.validators
{
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.Group;
	import org.apache.royale.jewel.Snackbar;

	/**
	 *  The FormValidator class is a specialty bead that can be used with
	 *  form control.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class FormValidator extends Validator
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FormValidator()
		{
			super();
			super.requiredFieldError = null;
		}

		private var _isError:Boolean;

		/**
		 *  Contains true if any validator in the form generated a validation failure.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function get isError():Boolean {
			return _isError;
		}

		/**
		 *  Override of the base class validate() method to call all validators in the form.
		 *  dispatch invalid/valid event when validation fails/succeeds. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function validate(event:Event = null):Boolean {
			_isError = false;
			validateAll(hostComponent as Group);
			if (isError) {
                if (requiredFieldError) Snackbar.show(requiredFieldError);
				hostComponent.dispatchEvent(new Event("invalid"));
			} else {
				hostComponent.dispatchEvent(new Event("valid"));
			}
			
			return !isError;
		}

		protected function validateAll(group:Group):void {
			for(var i:int=0; i < group.numElements; i++) {
				var child:UIBase = group.getElementAt(i) as UIBase;
				var validator:Validator = child.getBeadByType(Validator) as Validator;
				if (validator && !(validator is FormValidator)) {
					if(!validator.validate()) {
						_isError = true;
					}
				}
				if (child is Group) {
					validateAll(child as Group);
				}	
			}
		}
	}
}