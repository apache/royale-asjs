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
package org.apache.royale.style.stylebeads.layout
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class Display extends LeafStyleBase
	{
		public function Display()
		{
			super("", "display");
		}
		[Inspectable(category="General", enumeration="inline,block,inline-block,flow-root,flex,inline-flex,grid,inline-grid,contents,table,inline-table,table-caption,table-cell,table-column,table-column-group,table-footer-group,table-header-group,table-row-group,table-row,list-item,none", defaultValue="inline")]
		override public function set value(value:*):void
		{
			// TODO: Support `sr-only` and `not-sr-only`
			assert(["inline","block","inline-block","flow-root","flex","inline-flex","grid","inline-grid","contents","table","inline-table","table-caption","table-cell","table-column","table-column-group","table-footer-group","table-header-group","table-row-group","table-row","list-item","none"].indexOf(value) >= 0, "Invalid value for display: " + value);
			_value = value;
			calculatedRuleValue = calculatedSelector = value;
			if(value == "none")
				calculatedSelector = "hidden";
		}
	}
}