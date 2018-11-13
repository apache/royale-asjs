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

  [Event(name="close", type="org.apache.royale.events.CloseEvent")]
	/**
	 *  The Alert class is a component that displays a message and one or more buttons
	 *  in a view that pops up over all other controls and views. The Alert component
	 *  uses the AlertView bead to display a modal dialog with a title and a variety
	 *  of buttons configured through the flag property of its show() static function.
	 *  The Alert component uses the following beads:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model for the Alert.
	 *  org.apache.royale.core.IBeadView: the bead used to create the parts of the Alert.
	 *  org.apache.royale.core.IBeadController: the bead used to handle input events.
	 *  org.apache.royale.html.beads.IBorderBead: if present, draws a border around the Alert.
	 *  org.apache.royale.html.beads.IBackgroundBead: if present, places a solid color background below the Alert.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class Alert extends Group implements IPopUp
	{
		/**
		 *  The bitmask button flag to show the YES button.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const YES:uint    = 0x000001;
		
		/**
		 *  The bitmask button flag to show the NO button.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const NO:uint     = 0x000002;
		
		/**
		 *  The bitmask button flag to show the OK button.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const OK:uint     = 0x000004;
		
		/**
		 *  The bitmask button flag to show the Cancel button.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const CANCEL:uint = 0x000008;
		
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Alert()
		{
			super();
			typeNames = "Alert";
		}

		// note: only passing parent to this function as I don't see a way to identify
		// the 'application' or top level view without supplying a place to start to
		// look for it.
		/**
		*  This static method is a convenience function to quickly create and display an Alert. The
		*  text and parent paramters are required, the others will default.
		*
		*  @param String message The message content of the Alert.
		*  @param Object parent The object that hosts the pop-up.
		*  @param String title An optional title for the Alert.
		*  @param uint flags Identifies which buttons to display in the alert.
		*
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion Royale 0.0
		*/
    static public function show( message:String, parent:Object, title:String="", flags:uint=Alert.OK ) : Alert
		{
			var alert:Alert = new Alert();
			alert.message = message;
			alert.title  = title;
			alert.flags = flags;
			
			alert.show(parent);
            
			COMPILE::JS
			{
				alert.positioner.style.margin = 'auto';
				alert.positioner.style.left = "50%";
				alert.positioner.style.top = "50%";
				alert.positioner.style.width = "200px";
			}
			return alert;
		}
		
		/**
		 *  Shows the Alert anchored to the given parent object which is usally a root component such
		 *  as a UIView..
		 * 
		 *  @param Object parent The object that hosts the pop-up.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function show(parent:Object) : void
		{
			parent.addElement(this);
		}
		
		/**
		 *  The tile of the Alert.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get title():String
		{
			return IAlertModel(model).title;
		}

		public function set title(value:String):void
		{
			IAlertModel(model).title = value;
		}

		/**
		 *  The message to display in the Alert body.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get message():String
		{
			return IAlertModel(model).message;
		}
		public function set message(value:String):void
		{
			IAlertModel(model).message = value;
		}

		/**
		 *  The buttons to display on the Alert as bit-mask values.
		 *
		 *  Alert.YES
		 *  Alert.NO
		 *  Alert.OK
		 *  Alert.CANCEL
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get flags():uint
		{
			return IAlertModel(model).flags;
		}
		public function set flags(value:uint):void
		{
			IAlertModel(model).flags = value;
		}
	}
}
