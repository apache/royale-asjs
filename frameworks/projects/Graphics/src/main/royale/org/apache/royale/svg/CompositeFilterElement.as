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
package org.apache.royale.svg
{
	
	import org.apache.royale.events.Event;
	COMPILE::JS 
	{
		import org.apache.royale.graphics.utils.addSvgElementToElement;
	}

	/**
	 *  The CompositeFilterElement takes two objects and applies Porter/Duff operators
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class CompositeFilterElement extends FilterElement
	{
		private var _k4:Number
		private var _k3:Number
		private var _k2:Number
		private var _k1:Number;
		private var _in2:String;
		private var _operator:String;

		public function CompositeFilterElement()
		{
		}
		
		
		/**
		 * @royaleignorecoercion Element
		 */
		override public function build():void
		{
			COMPILE::JS 
			{
				super.build();
				filterElement.setAttribute("in2", in2);
				if (operator == "arithmetic")
				{
					filterElement.setAttribute("k1", k1);
					filterElement.setAttribute("k2", k2);
					filterElement.setAttribute("k3", k3);
					filterElement.setAttribute("k4", k4);
				}
				filterElement.setAttribute("operator", operator);
			}
		}

		public function get in2():String 
		{
			return _in2;
		}
		
		public function set in2(value:String):void 
		{
			_in2 = value;
		}

		public function get operator():String 
		{
			return _operator;
		}
		
		public function set operator(value:String):void 
		{
			_operator = value;
		}

		COMPILE::JS
		override protected function get filterElementType():String
		{
			return "feComposite";
		}


		public function get k1():Number 
		{
			return _k1;
		}
		
		public function set k1(value:Number):void 
		{
			_k1 = value;
		}

		public function get k2():Number 
		{
			return _k2;
		}
		
		public function set k2(value:Number):void 
		{
			_k2 = value;
		}

		public function get k3():Number 
		{
			return _k3;
		}
		
		public function set k3(value:Number):void 
		{
			_k3 = value;
		}

		public function get k4():Number 
		{
			return _k4;
		}
		
		public function set k4(value:Number):void 
		{
			_k4 = value;
		}
	}
}

