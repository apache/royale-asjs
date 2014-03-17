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
package org.apache.flex.utils
{
	import org.apache.flex.core.UIBase;

	/**
	 *  The UIUtils class is a collection of static functions that provide utility
	 *  features to UIBase objects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class UIUtils
	{
		/**
		 * @private
		 */
		public function UIUtils()
		{
			throw new Error("UIUtils should not be instantiated.");
		}
		
		/**
		 *  Centers the given item relative to another item. Typically the item being centered is
		 *  a child or sibling of the second item. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static function center( item:UIBase, relativeTo:UIBase ):void
		{
			var xpos:Number = (relativeTo.width - item.width)/2;
			var ypos:Number = (relativeTo.height - item.height)/2;
			
			item.x = xpos;
			item.y = ypos;
		}
	}
}