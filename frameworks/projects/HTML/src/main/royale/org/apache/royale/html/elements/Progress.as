////////////////////////////////////////////////////////////////////////////////
//
//	Licensed to the Apache Software Foundation (ASF) under one or more
//	contributor license agreements.	See the NOTICE file distributed with
//	this work for additional information regarding copyright ownership.
//	The ASF licenses this file to You under the Apache License, Version 2.0
//	(the "License"); you may not use this file except in compliance with
//	the License.	You may obtain a copy of the License at
//
//			http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.html.elements
{
	import org.apache.royale.core.UIBase;

		COMPILE::JS
		{
				import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
		}
		import org.apache.royale.html.NodeElementBase;

	/**
	 *	The Progress class represents an HTML <progress> element
		 *	
	 *	
		 *	@toplevel
	 *	@langversion 3.0
	 *	@playerversion Flash 10.2
	 *	@playerversion AIR 2.6
	 *	@productversion Royale 0.9.5
	 */
	public class Progress extends NodeElementBase
	{
		/**
		 *	constructor.
		 *
		 *	@langversion 3.0
		 *	@playerversion Flash 10.2
		 *	@playerversion AIR 2.6
		 *	@productversion Royale 0.9.5
		 */
		public function Progress()
		{
			super();
		}

		/**
		 * @royaleignorecoercion HTMLProgressElement
		 */
		COMPILE::JS
		private function get progress():HTMLProgressElement
		{
			return element as HTMLProgressElement;
		}

		COMPILE::SWF
		private var _value:Number;

		/**
		 *	A Number value that reflects the current value;
		 *	if the progress bar is an indeterminate progress bar, it returns 0.
		 *	
		 *	@langversion 3.0
		 *	@playerversion Flash 10.2
		 *	@playerversion AIR 2.6
		 *	@productversion Royale 0.9.5
		 */
		public function get value():Number
		{
			COMPILE::SWF
			{
				return _value;
			}
			COMPILE::JS
			{
				return progress.value;
			}
		}


		public function set value(value:Number):void
		{
			COMPILE::SWF
			{
				_value = value;
			}
			COMPILE::JS
			{
				progress.value = value;
			}
		}

		COMPILE::SWF
		private var _max:Number;

		/**
		 *	A Number value reflecting the content attribute of the same name,
		 *  limited to numbers greater than zero. Its default value is 1.0.
		 *	
		 *	@langversion 3.0
		 *	@playerversion Flash 10.2
		 *	@playerversion AIR 2.6
		 *	@productversion Royale 0.9.5
		 */
		public function get max():Number
		{
			COMPILE::SWF
			{
				if(isNaN(_max))
					return 1;
				return _max;
			}
			COMPILE::JS
			{
				return progress.max;
			}
		}

		public function set max(value:Number):void
		{
			COMPILE::SWF
			{
				_max = value;
			}
			COMPILE::JS
			{
				progress.max = value;
			}
		}

		/**
		 *	Returns a Number value returning the result of dividing the
		 *  current value (value) by the maximum value (max).
		 *  If the progress bar is an indeterminate progress bar, it returns -1.
		 *	
		 *	@langversion 3.0
		 *	@playerversion Flash 10.2
		 *	@playerversion AIR 2.6
		 *	@productversion Royale 0.9.5
		 */
		public function get position():Number
		{
			COMPILE::SWF
			{
				if(determinate)
					return value / max;
				
				return -1;
			}
			COMPILE::JS
			{
				return progress.position;
			}
		}

		/**
		 *	Whether the progress bar is determinate (true) or indeterminate (false)
		 *	
		 *	@langversion 3.0
		 *	@playerversion Flash 10.2
		 *	@playerversion AIR 2.6
		 *	@productversion Royale 0.9.5
		 */
		public function get determinate():Boolean
		{
			COMPILE::SWF
			{
				return !isNaN(_value);
			}

			COMPILE::JS
			{
				return progress.hasAttribute("value");
			}
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addElementToWrapper(this,'progress');
		}
	}
}
