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
package org.apache.flex.mdl.beads
{
	COMPILE::SWF
	{
		import flash.text.TextFieldType;			
		
		import org.apache.flex.core.CSSTextField;
	}
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;

    import org.apache.flex.mdl.TextField;
	
	/**
	 *  The TextPrompt class is a specialty bead that can be used with
	 *  any TextField control. The bead places a string into the input field
	 *  when there is no value associated with the text property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Numeric implements IBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Numeric()
		{
		}
		
		private var _pattern:String = "-?[0-9]*(\.[0-9]+)?";
		
		/**
		 *  The string to use as numeric pattern.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get pattern():String
		{
			return _pattern;
		}
		public function set pattern(value:String):void
		{
			_pattern = value;
		}
		
        private var _text:String = "Input is not a number!";

        /**
		 *  The string to use as error text in the associated span.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get text():String
        {
            return _text;
        }
        public function set text(value:String):void
        {
            _text = value;
        }

		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion HTMLInputElement
		 *  @flexjsignorecoercion org.apache.flex.core.UIBase;
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			COMPILE::JS
			{
				var mdlTi:TextField = value as TextField;
                mdlTi.input.setAttribute('pattern', pattern);

                var span:HTMLSpanElement = document.createElement('span') as HTMLSpanElement;
                span.className = "mdl-textfield__error";

                var spanTextNode:Text = document.createTextNode(text) as Text;
                span.appendChild(spanTextNode);

                mdlTi.positioner.appendChild(span);
			}
		}
	}
}
