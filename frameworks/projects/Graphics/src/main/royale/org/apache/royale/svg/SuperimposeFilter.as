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
	
	/**
	 *  SuperimposeFilter composes superimposes several filters one on top of the other.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class SuperimposeFilter extends Filter
	{
		public function SuperimposeFilter()
		{
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.svg.IChainableFilter
		 */
		COMPILE::JS
		override protected function filter():void
		{
			var newChildren:Array = [];
			var results:Array = ["SourceGraphic"];
			for (var i:int = 0; i < children.length; i++)
			{
				var chainable:IChainableFilter = children[i] as IChainableFilter;
				var resultName:String = "chainableResult" + i;
				chainable.result = resultName;
				if (chainable.isNice)
				{
					results.unshift(resultName);
				} else
				{
					results.push(resultName);
				}
				chainable.build();
				addArray(newChildren, chainable.children);
			}
			var merge:MergeFilterElement = new MergeFilterElement();
			merge.results = results;
			newChildren.push(merge);
			children = newChildren;
			super.filter();
		}
		
		COMPILE::JS
		private function addArray(original:Array, addition:Array):void
		{
			for (var i:int = 0; i < addition.length; i++)
			{
				original.push(addition[i]);
			}
		}
	}
}

