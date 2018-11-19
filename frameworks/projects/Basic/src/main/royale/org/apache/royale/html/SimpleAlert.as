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
	import org.apache.royale.core.IAlertModel;
	import org.apache.royale.core.IPopUp;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	
	[Event(name="close", type="org.apache.royale.events.Event")]
	
	/**
	 *  The SimpleAlert class is a component that displays a message and an OK button. The
	 *  SimpleAlert converts directly to window.alert() for HTML. SimpleAlert uses
	 *  the following beads:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model, which includes the message.
	 *  org.apache.royale.core.IBeadView:  the bead that constructs the visual parts of the Alert.
	 *  org.apache.royale.core.IBeadController: the bead responsible for handling input events.
	 *  org.apache.royale.html.beads.IBorderBead: a bead, if present, that draws a border around the control.
	 *  org.apache.royale.html.beads.IBackgroundBead: a bead, if present, that creates a solid-color background.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SimpleAlert extends UIBase implements IPopUp
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SimpleAlert()
		{
			super();
			
			typeNames = "SimpleAlert";
		}
		
		/**
		 *  The message to display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IAlertModel
		 */
		private function get message():String
		{
			return IAlertModel(model).message;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IAlertModel
		 */
		private function set message(value:String):void
		{
			IAlertModel(model).message = value;
		}
		
		/**
		 *  The HTML message to display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IAlertModel
		 */
		private function get htmlMessage():String
		{
			return IAlertModel(model).htmlMessage;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IAlertModel
		 */
		private function set htmlMessage(value:String):void
		{
			IAlertModel(model).htmlMessage = value;
		}
		
		/**
		 *  This function causes the SimpleAlert to appear. The parent is used for ActionScript and
		 *  identifies the IPopUpParent that manages the alert.
		 * 
		 *  @param Object parent The object that hosts the pop-up.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function showAlert(parent:Object) : void
		{
			parent.addElement(this);
		}
		
		/**
		 *  A convenience function to compose and display the alert.
		 * 
		 *  @param String message The content to display in the SimpleAlert.
		 *  @param Object parent The object that hosts the pop-up.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		static public function show(message:String, parent:Object):SimpleAlert
		{
            COMPILE::SWF
            {
                var alert:SimpleAlert = new SimpleAlert();
                alert.message = message;
                alert.showAlert(parent);                    
                
                return alert;
            }
            COMPILE::JS
            {
                alert(message);
                return null;
            }
		}
		
	}
}
