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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.core.UIBase;
	import org.apache.royale.textLayout.compose.ITextFlowTableBlock;
	
	/**
	 * The sprite that contains the table cells. 
	 **/
	public class TableBlockContainer extends UIBase
	{
//TODO this should probably be an interface to support multiple UI implementations.
// It's probably not going to work with either SVG or Canvas without hacks.
		
		public function TableBlockContainer()
		{
			super();
		}
		
		/**
		 * A reference to the TextFlowTableBlock
		 **/
		public var userData:ITextFlowTableBlock;
		public function getTableWidth():Number
		{
			if(!userData)
				return NaN;
			if(!userData.parentTable)
				return NaN;
			return userData.parentTable.width;
		}
	}
}
