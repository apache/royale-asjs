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
package org.apache.royale.jewel
{
    import org.apache.royale.core.IPopUp;
    import org.apache.royale.core.StyledUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.beads.models.SnackbarModel;

    [Event(name="action", type="org.apache.royale.events.Event")]
	/**
	 *  The Snackbar class is a component that provide brief messages
     *  about app processes at the bottom that pops up over all other controls.
     *  The Snackbar component uses the SnackbarView bead to display messages
     *  and can contain a single action which configured through the action property.
     *  Because Snackbar disappear automatically, the action shouldn’t be “Dismiss” or “Cancel.”
	 *  The Snackbar component uses the following beads:
	 * 
	 *  org.apache.royale.core.IBeadModel: the data model for the Snackbar.
	 *  org.apache.royale.core.IBeadView: the bead used to create the parts of the Snackbar.
	 *  org.apache.royale.core.IBeadController: the bead used to handle disappear automatically.
	 *  
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Snackbar extends StyledUIBase implements IPopUp
	{
		/**
		 *  constructor.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Snackbar()
		{
			super();
			
			typeNames = "jewel snackbar layout";
		}

		private var _isAddedToParent:Boolean;

		/**
		 *  Action event name.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public static const ACTION:String = "action";
		
		/**
		 *  The number of milliseconds to show the Snackbar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get duration():int
		{
			return SnackbarModel(model).duration;
		}

		public function set duration(value:int):void
		{
			SnackbarModel(model).duration = value;
		}

		/**
		 *  The text message to display in the Snackbar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get message():String
		{
			return SnackbarModel(model).message;
		}

		public function set message(value:String):void
		{
			SnackbarModel(model).message = value;
		}

		/**
		 *  The action to display on the Snackbar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get action():String
		{
			return SnackbarModel(model).action;
		}

		public function set action(value:String):void
		{
			SnackbarModel(model).action = value;
		}

        /**
          *  This static method is a convenience function to quickly create and display an Snackbar. The
          *  message paramters are required, the others will default.
          *
          *  @param String message The message content of the Snackbar.
          *  @param int duration How long to show the Snackbar for.
		  *  @param String actionText The action text of the Snackbar.
          *  @param Object parent The object that hosts the pop-up.
          *
          *  @langversion 3.0
          *  @playerversion Flash 10.2
          *  @playerversion AIR 2.6
          *  @productversion Royale 0.9.4
          */
        static public function show(message:String, duration:int = 4000, actionText:String = null, parent:Object = null) : Snackbar
		{
            var snackbar:Snackbar = new Snackbar();
            snackbar.message = message;
			snackbar.duration = duration;
			snackbar.action = actionText;
           	snackbar.show(parent);
			return snackbar;
		}

		
		/**
		 *  Shows the Snackbar anchored to a root component such
		 *  as body
		 * 
		 *  @param Object parent The object that hosts the pop-up.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function show(parentContainer:Object = null) : void
		{
            COMPILE::JS
			{
				if (parentContainer)
				{
					_isAddedToParent = true;
                    parentContainer.element.appendChild(element);
				}
				else
				{
					_isAddedToParent = false;
					var body:HTMLElement = document.getElementsByTagName('body')[0];
					body.appendChild(element);
				}
				addedToParent();
			}

            COMPILE::SWF
			{
                parentContainer.addElement(this);
			}
		}

        /**
		 *  Dismiss the snackbar.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function dismiss(event:Event = null):void
		{
			COMPILE::JS
			{
				removeAllListeners();

				if (_isAddedToParent)
				{
					parent["element"].removeChild(element);
				}
				else
				{
					var body:HTMLElement = document.getElementsByTagName('body')[0];
					body.removeChild(element);
				}

				_isAddedToParent = false;
			}
		}
	}
}
