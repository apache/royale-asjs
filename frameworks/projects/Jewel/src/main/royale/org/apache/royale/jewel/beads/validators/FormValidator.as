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
	import org.apache.royale.jewel.Group;
	import org.apache.royale.jewel.Snackbar;
	import org.apache.royale.core.IStrand;

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

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			hostComponent = value as UIBase;
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
            iterateAll(hostComponent as Group, true);
			dispatchValidEvent();

			return !isError;
		}

		protected function iterateAll(group:Group, validateAction:Boolean, visibleOnly:Boolean = true):void {
			for(var i:int=0; i < group.numElements; i++) {
				var child:UIBase = group.getElementAt(i) as UIBase;
				if (visibleOnly && !child.visible) continue;
				var validator:Validator = child.getBeadByType(Validator) as Validator;
                if (validator) {
					if (validator == this) {
						if (!validateAction) destroyErrorTip();
					} else {
                        if (validator is FormValidator) {
                            if (validateAction) {
                                if(!validator.validate()) {
                                    _isError = true;
                                }
                            } else {
                                FormValidator(validator).removeAllErrorTips();
                            }
                            continue;
                        }

                        if (validateAction) {
                            if(!validator.validate()) {
                                _isError = true;
                            }
                        } else {
                            validator.destroyErrorTip();
                        }
					}
                }
				if (child is Group) {
                    iterateAll(child as Group, validateAction, visibleOnly);
				}
			}
		}

        /**
         *  Utility function to remove all error tips below an upper level which defaults
		 *  to the host of this FormValidator bead. If an explicit group is passed as the upper
		 *  level to iterate from, it should by convention be some child in the hierarchy below
		 *  the host of this FormValidator bead, but that requirement is not enforced.
		 *
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
		 *
		 *  @royaleignorecoercion org.apache.royale.jewel.Group
         */
		public function removeAllErrorTips(below:Group = null, onlyVisible:Boolean = false):void{
			if (!below) below = hostComponent as Group;
			if (below == (hostComponent as Group)) {
                destroyErrorTip();
			}
            iterateAll(below, false, onlyVisible);
		}

		protected function dispatchValidEvent():void
		{
			if (isError)
			{
				if (requiredFieldError)
				{
					Snackbar.show(requiredFieldError);
				}
				hostComponent.dispatchEvent(new Event("invalid"));
			}
			else
			{
				hostComponent.dispatchEvent(new Event("valid"));
			}
		}
	}
}
