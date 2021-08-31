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
	 *  The LowerCase class is a specialty bead that can be used with
	 *  any Jewel TextInputBase control. The bead makes all text change to lower case
	 *  Note: if you only need text to look lower case but wants the text remain unchanged
	 *  you can use CSS text-transform: lowercase
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class LowerCase implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function LowerCase()
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
			host.addEventListener(Event.CHANGE, changeToLowerCase);
			host.text = host.text.toLowerCase();
		}
		
		/**
		 * Change text to lower case as user types
		 * 
		 * @private
		 */
		protected function changeToLowerCase(event:Event):void
		{
			COMPILE::JS
			{
			var input:HTMLInputElement = event.target.input as HTMLInputElement;
			var start:Number = input.selectionStart;
			var end:Number = input.selectionEnd;
			input.value = input.value.toLowerCase();
			input.setSelectionRange(start, end);
			}
		}
	}
}