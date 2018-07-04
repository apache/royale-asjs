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
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.IEventDispatcher;
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
	public class CompositeFilterElement implements IBead
	{
		private var _strand:IStrand;
		private var _in:String;
		private var _in2:String;
		private var _result:String;
		private var _operator:String;

		public function CompositeFilterElement()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			(_strand as IEventDispatcher).addEventListener('beadsAdded', onInitComplete);
		}
		
		/**
		 * @royaleignorecoercion Element
		 */
		protected function onInitComplete(e:Event):void
		{
			COMPILE::JS 
			{
				var filter:Element = (_strand.getBeadByType(Filter) as Filter).filterElementWrapper;
				var compositeElement:Element = addSvgElementToElement(filter, "feComposite") as Element;
				compositeElement.setAttribute("in", in);
				compositeElement.setAttribute("in2", in2);
				compositeElement.setAttribute("result", result);
				compositeElement.setAttribute("operator", operator);
			}
		}

		public function get in():String 
		{
			return _in;
		}
		
		public function set in(value:String):void 
		{
			_in = value;
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

		public function get result():String 
		{
			return _result;
		}
		
		public function set result(value:String):void 
		{
			_result = value;
		}
	}
}

