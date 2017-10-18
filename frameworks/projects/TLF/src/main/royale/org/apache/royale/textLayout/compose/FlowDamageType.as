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
package org.apache.royale.textLayout.compose
{
	/**
	 *  The FlowDamageType class is an enumeration class that defines types of damage for damage methods and events.
	 * When the text content is updated, these changes are reflected in the TextLines after an update. TextLines are 
	 * marked with a flag that specifies whether or not they are valid, or up to date with all text
	 * changes. When the text is first updated, all lines are marked valid or static. After the text has been changed,
	 * and before the next update, lines will be marked with a FlowDamageType that specifies what about the line
	 * is invalid. Once the update is done, lines will again be marked as valid or static.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public class FlowDamageType
	{
		/** 
		 * Value is used to set the <code>validity</code> property if the text content has changed since the
		 * line was originally created. Invalid lines needs to be recreated before they are used for selection
		 * or to display the text content changes.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see org.apache.royale.textLayout.compose.TextFlowLine#validity	 	 */
		static public const INVALID:String = "invalid";
		
		/**
		 * Value is used to set the <code>validity</code> property if the line has been invalidated by other lines 
		 * moving around. For instance, a line above may have been created, so this line needs to be moved down.
		 * The text line might or might not need recreating at the next compose operation. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 *
	 	 * @see org.apache.royale.textLayout.compose.TextFlowLine#validity
	 	 */
		static public const GEOMETRY:String = "geometry";
	}
}
