
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
package mx.supportClasses
{
COMPILE::JS{
	import goog.events.EventTarget;
}


	import mx.controls.List;

	import org.apache.royale.core.IPopUp;

	//--------------------------------------
	//  Events
	//--------------------------------------

	/**
	 *  @copy org.apache.royale.core.ISelectionModel#change
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]
    
    /**
     *  The ComboBoxList class is the List class used internally
     *  by ComboBox as the dropdown/popup.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.10
     */
	public class ComboBoxList extends List implements IPopUp

	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 */
		public function ComboBoxList()
		{
			super();
			typeNames += ' ComboBoxList';
		}


		/*COMPILE::JS
		override public function getParentEventTarget():goog.events.EventTarget{
			//there may be a better way to do this, need to check how Flex does it....
			//but the dropdown list owner is the ComboBox itself, so we consider this as the parent target for bubbling events.
			if (this.owner) return this.owner as EventTarget;
			//fallback:
			return this.parent as EventTarget;
		}*/
	}
}
