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
    import org.apache.royale.jewel.beads.validators.FormValidator;
    import org.apache.royale.events.Event;

	/**
	 *  The FormValidatorWithoutSnackbar class is a specialty bead that can be used with
	 *  form control. It prevents from displaying Snackbar notification in case of errors.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.9
	 */
	public class FormValidatorWithoutSnackbar extends FormValidator 
	{
		public function FormValidatorWithoutSnackbar()
		{
			super();
		}

		/**
		 *  Override of the base class dispatchValidEvent in order to remove snackbar notification.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.9
		 */
		override protected function dispatchValidEvent():void
		{
			//Override this method in order to remove snackbar notification
			if (isError)
			{
				hostComponent.dispatchEvent(new Event("invalid"));
			}
			else
			{
				hostComponent.dispatchEvent(new Event("valid"));
			}
		}
	}
}