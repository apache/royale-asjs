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
	 *  The MergeFilterElement merges several filter elements
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class MergeFilterElement extends FilterElement
	{
		private var _strand:IStrand;
		private var _results:Array;

		public function MergeFilterElement()
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
				for (var i:int = 0; i < results.length; i++)
				{
					var mergeNode:Element = addSvgElementToElement(filterElement, "feMergeNode") as Element;
					mergeNode.setAttribute("in", "" + results[i]);
				}
			}
		}

		COMPILE::JS
		override protected function get filterElementType():String
		{
			return "feMerge";
		}

		public function get results():Array 
		{
			return _results;
		}
		
		public function set results(value:Array):void 
		{
			_results = value;
		}
	}
}

