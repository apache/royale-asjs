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
package org.apache.royale.textLayout.events {
	import org.apache.royale.events.IRoyaleEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.textLayout.elements.TextFlow;
	
	/** 
	 * A TextFlow instance dispatches this each time it is marked as damaged.  Damage can be caused by changes to the model or changes to the layout.
	 * 
	 * @see org.apache.royale.textLayout.elements.TextFlow 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class DamageEvent extends Event
	{
		/** Event type for DamageEvent */
	    public static const DAMAGE:String = "damage";

		private var _textFlow:TextFlow;
		private var _damageAbsoluteStart:int;
		private var _damageLength:int;	
		
		/** Constructor
		 * @param damageAbsoluteStart text index of the start of the damage
		 * @param damageLength length of text that was damaged
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function DamageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, textFlow:TextFlow =  null, damageAbsoluteStart:int = 0, damageLength:int = 0)
		{
			_textFlow = textFlow;
			_damageAbsoluteStart = damageAbsoluteStart;
			_damageLength = damageLength;
			super(type, bubbles, cancelable);
		}
		
      	/** @private */
		override public function cloneEvent():IRoyaleEvent
		{
			return new DamageEvent(type, bubbles, cancelable, _textFlow, _damageAbsoluteStart, _damageLength);
		}
		
		/**
		 * TextFlow owning the damage 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		public function get textFlow():TextFlow
		{ return _textFlow; }
		
		/**
		 * Absolute start of the damage 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		public function get damageAbsoluteStart():int
		{ return _damageAbsoluteStart; }
		
		/**
		 * Length of the damage 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		public function get damageLength():int
		{ return _damageLength; }
	}
}

