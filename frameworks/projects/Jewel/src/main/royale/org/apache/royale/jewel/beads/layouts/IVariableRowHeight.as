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
package org.apache.royale.jewel.beads.layouts
{
	/**
	 *  Jewel IVariableRowHeight is the interface used by Jewel Layouts that implement gaps.
	 */
	public interface IVariableRowHeight
	{
		/**
		 *  Specifies whether layout elements are allocated their preferred height.
		 *  Setting this property to false specifies fixed height rows.
		 *  
		 *  If false, the actual height of each layout element is the value of rowHeight.
		 *  The default value is true. 
		 *  
		 *  Note: From Flex but we should see what to do in Royale -> Setting this property to false causes the layout to ignore the layout elements' percentHeight property.
		 */
		function get variableRowHeight():Boolean;
		function set variableRowHeight(value:Boolean):void;
	}
}