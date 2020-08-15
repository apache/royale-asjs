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
package org.apache.royale.jewel.beads.controls.textinput
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;
	
	/**
	 *  The UpperCase class is a specialty bead that can be used with
	 *  any Jewel TextInputBase control. The bead makes all text change to upper case
	 *  Note: if you only need text to look upper case but wants the text remain unchanged
	 *  you can use CSS text-transform: uppercase
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class UpperCase implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function UpperCase()
		{
		}

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
			var host:TextInputBase = value as TextInputBase;
			host.addEventListener(Event.CHANGE, changeToUpperCase);
			host.text = host.text.toUpperCase();
		}
		
		/**
		 * Change text to upper case as user types
		 * 
		 * @private
		 */
		protected function changeToUpperCase(event:Event):void
		{
			COMPILE::JS
			{
			var input:HTMLInputElement = event.target.input as HTMLInputElement;
			var start:Number = input.selectionStart;
			var end:Number = input.selectionEnd;
			input.value = input.value.toUpperCase();
			input.setSelectionRange(start, end);
			}
		}
	}
}