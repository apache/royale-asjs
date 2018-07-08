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
	 *  FilterElement abstracts some methods and vars for elements that can go in an SVG filter
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class FilterElement implements IBead
	{
		private var _strand:IStrand;
		private var _result:String;
		COMPILE::JS
		{
			private var _filterElement:Element;
		}

		public function FilterElement()
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
				var filter:Element = getFilterElementWrapper();
				_filterElement = addSvgElementToElement(filter, filterElementType) as Element;
				if (result)
				{
					filterElement.setAttribute("result", result);
				}
			}
		}
		
		/**
		 * @royaleignorecoercion Element
		 */
		COMPILE::JS
		protected function getFilterElementWrapper():Element
		{
			return (_strand.getBeadByType(Filter) as Filter).filterElementWrapper;
		}

		/**
		 *  Reference to the filter element result. This can later be used as input for a subsequent filter element.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get result():String 
		{
			return _result;
		}
		
		public function set result(value:String):void 
		{
			_result = value;
		}
		
		COMPILE::JS
		protected function get filterElementType():String
		{
			// override this
			return "";
		}
		
		/**
		 * @royaleignorecoercion Element
		 */
		COMPILE::JS
		protected function get filterElement():Element
		{
			return _filterElement;
		}
	}
}

