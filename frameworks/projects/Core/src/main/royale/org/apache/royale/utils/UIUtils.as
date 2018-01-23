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
package org.apache.royale.utils
{
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IPopUpHost;
	import org.apache.royale.core.IUIBase;

	/**
	 *  The UIUtils class is a collection of static functions that provide utility
	 *  features to UIBase objects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
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
		 *  @param item The component item being centered.
		 *  @param relativeTo The component used as reference for the centering.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static function center( item:IUIBase, relativeTo:IUIBase ):void
		{
			var xpos:Number = (relativeTo.width - item.width)/2;
			var ypos:Number = (relativeTo.height - item.height)/2;
			
			item.x = xpos;
			item.y = ypos;
		}
		
		/**
		 *  Given a component starting point, this function walks up the parent chain
		 *  looking for a component that implements the IPopUpHost interface. The function
		 *  either returns that component or null if no IPopUpHost can be found. 
		 * 
		 *  @param start A component to start the search.
		 *  @return A component that implements IPopUpHost or null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static function findPopUpHost(start:IUIBase):IPopUpHost
		{
			while( start != null && !(start is IPopUpHost) && start is IChild ) {
				start = IChild(start).parent as IUIBase;
			}
			
			return start as IPopUpHost;
		}
		
		/**
		 *  Removes the given component from the IPopUpHost. 
		 * 
		 *  @param start A component to start the search.
		 *  @return A component that implements IPopUpHost or null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static function removePopUp(popUp:IChild):void
		{
			var start:IParent = popUp.parent;
			while( start != null && !(start is IPopUpHost) && start is IChild ) {
				start = IChild(start).parent;
			}
			(start as IPopUpHost).removeElement(popUp);
		}
	}
}
