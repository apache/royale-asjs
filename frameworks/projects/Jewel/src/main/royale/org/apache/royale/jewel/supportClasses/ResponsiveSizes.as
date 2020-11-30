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
package org.apache.royale.jewel.supportClasses
{
	/**
	 *  The ResponsiveSizes declares consants that are related to SASS variables
     *  created to provide media queries for different screen sizes
     *  
     *  by default:
     * 
     *  // DEVICE DIMENSIONS
     *  $phone: 0px
     *  $tablet: 768px
     *  $desktop: 992px
     *  $widescreen: 1200px
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class ResponsiveSizes
	{
        public static const PHONE:String = "phone";
		public static const TABLET:String = "tablet";
		public static const DESKTOP:String = "desktop";
		public static const WIDESCREEN:String = "widescreen";
		public static const FULL:String = "full";
        
        public static const PHONE_BREAKPOINT:Number = 0;
		public static const TABLET_BREAKPOINT:Number = 768;
		public static const DESKTOP_BREAKPOINT:Number = 992;
		public static const WIDESCREEN_BREAKPOINT:Number = 1200;
		public static const FULL_BREAKPOINT:Number = 1600;

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function ResponsiveSizes()
		{
		}
	}
}
