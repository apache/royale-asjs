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
package org.apache.royale.jewel.beads.models
{	
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
		
	/**
	 *  The PopUpModel class bead defines the data associated with an org.apache.royale.jewel.PopUp
	 *  component. This includes the duration - how long to show the view for.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class PopUpModel extends EventDispatcher implements IBeadModel
	{
        /**
         *  Constructor.
         *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.4
         */
		public function PopUpModel()
		{
            super();
		}

		private var _strand:IStrand;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}

		// private var _message:String;

        // [Bindable("messageChange")]
        // public function get message():String
		// {
		// 	return _message;
		// }
		
        /**
         *  Set message to be displayed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		// public function set message(value:String):void
		// {
        //     if (value == null)
        //         value = "";
		// 	if (value != _message)
		// 	{
		// 		_message = value;
		// 		dispatchEvent(new Event("messageChange"));
		// 	}
		// }
		
		// private var _action:String;
        
        // [Bindable("actionChange")]
		// public function get action():String
		// {
		// 	return _action;
		// }
		
        /**
         *  Set action to be displayed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		// public function set action(value:String):void
		// {
		// 	if (value != _action)
		// 	{
		// 		_action = value;
		// 		dispatchEvent(new Event("actionChange"));
		// 	}
		// }

        private var _duration:int = 4000;

        [Bindable("durationChange")]
		public function get duration():int
		{
			return _duration;
		}
		
        /**
         *  Set how long to show the view for.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function set duration(value:int):void
		{
			if (value != _duration)
			{
				_duration = value;
				dispatchEvent(new Event("durationChange"));
			}
		}
	}
}