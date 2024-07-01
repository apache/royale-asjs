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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
    import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;

	/**
	 *  The RestrictValidator class is a specialty bead that can be used with
	 *  TextInput control.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.11
	 */
	public class RestrictValidator extends StringValidator
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 */
		public function RestrictValidator()
		{
			super();
		}

        private var _pattern:RegExp;

		/**
		 *  The RegExp to validate TextInput.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 */
		public function get pattern():RegExp
		{
			return _pattern;
		}

		public function set pattern(value:RegExp):void
		{
		    if (_pattern != value)
		    {
			    _pattern = value;
			}
		}

		/**                         	
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
		}

		/**
		 *  Override of the base class validate() method to validate a String.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.11
		 */
		override public function validate(event:Event = null):Boolean {
			if (super.validate(event))
			{
			    var txt:TextInputBase = hostComponent as TextInputBase;
			    if (pattern && pattern.test(txt.text))
			    {
			        createErrorTip(requiredFieldError);
			    }
			    else
			    {
			        destroyErrorTip();
			    }
			}
			return !isError;
		}
	}
}
