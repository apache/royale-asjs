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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IFormatter;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	/**
	 *  The FormatableTextInputView class is a View bead that extends TextInputWithBorderView
	 *  and is capable of working with a format bead. When a format bead dispatches a
	 *  formatChanged event, the FormatableTextInputView bead copies the formatted string to
	 *  to the text field.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class FormatableTextInputView extends TextInputWithBorderView
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function FormatableTextInputView()
		{
			super();
		}
		
		private var _formatter:IFormatter;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			IEventDispatcher(value).addEventListener("beadsAdded",handleBeadsAdded);
		}
		
		/**
		 * @private
		 */
		private function handleBeadsAdded(event:Event):void
		{
			_formatter = _strand.getBeadByType(IFormatter) as IFormatter;
		}
		
		override public function set text(value:String):void{
			if(_formatter)
				value = _formatter.format(value);
			super.text = value;
		}
	}
}
