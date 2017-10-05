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
package org.apache.royale.textLayout.container
{
	import org.apache.royale.textLayout.property.PropertyFactory;
	import org.apache.royale.textLayout.property.Property;




	/**
	 *  The ScrollPolicy class is an enumeration class that defines values for setting the <code>horizontalScrollPolicy</code> and 
	 *  <code>verticalScrollPolicy</code> properties of the ContainerController class, which defines a text flow 
	 *  container. 
	 *
	 *  @see ContainerController#horizontalScrollPolicy
	 *  @see ContainerController#verticalScrollPolicy
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public final class ScrollPolicy
	{
		/** 
		 * Specifies that scrolling is to occur if the content exceeds the container's dimension. The runtime calculates 
		 * the number of lines that overflow the container and the user can navigate to them with cursor keys, by drag selecting,
		 * or by rotating the mouse wheel. You can also cause scrolling to occur by setting the corresponding position value, 
		 * either <code>ContainerController.horizontalScrollPosition</code> or <code>ContainerController.verticalScrollPosition</code>. Also, the runtime can automatically 
		 * scroll the contents of the container during editing.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const AUTO:String = "auto";
		
		/** 
		 * Causes the runtime to not display overflow lines, which means that the user cannot navigate to them. 
		 * In this case, setting the corresponding <code>ContainerController.horizontalScrollPosition</code> and 
		 * <code>ContainerController.verticalScrollPosition</code> properties have no effect. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const OFF:String = "off";
		
		/** 
		 * Specifies that scrolling is available to access content that exceeds the container's dimension. The runtime calculates the 
		 * number of lines that overflow the container and allows the user to scroll them into view with the cursor keys, by drag selecting, 
		 * or by rotating the mouse wheel. You can also scroll by setting the corresponding position value, either 
		 * <code>ContainerController.horizontalScrollPosition</code> or <code>ContainerController.verticalScrollPosition</code>. Also, the runtime can automatically scroll the contents 
		 * of the container during editing.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const ON:String = "on";		
		
		static private var _scrollPolicyPropertyDefinition:Property;
		/** Shared definition of the scrollPolicy property. @private */
		static public function get scrollPolicyPropertyDefinition():Property{
			if(_scrollPolicyPropertyDefinition == null)
				_scrollPolicyPropertyDefinition = PropertyFactory.enumString("scrollPolicy", ScrollPolicy.AUTO, false, null, ScrollPolicy.AUTO, ScrollPolicy.OFF, ScrollPolicy.ON);
			
			return _scrollPolicyPropertyDefinition;
		}
	}
}
