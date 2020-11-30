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
package org.apache.royale.jewel
{
	import org.apache.royale.jewel.View;

	/**
	 *  The ResponsiveView class is the main Container component capable of 
	 *  parenting other components in a responsive Jewel Application.
	 *  
	 *  ResponsiveView doesn't need to specify `width` and `height` since are 
	 *  sized 100% in both directions by default. In this way we can use the
	 *  width of the application container to apply responsive rules on any 
	 *  part of the application.
	 *  
	 *  It normaly can host a TopAppBar, a Drawer and a Container with other organized content for
	 *  navigation
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ResponsiveView extends View
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ResponsiveView()
		{
			super();

            typeNames = "responsive-view";
		}
	}
}
