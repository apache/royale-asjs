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
    import org.apache.royale.core.Application;
    import org.apache.royale.core.SimpleCSSValuesImpl;
		
	/**
	 * Jewel Application holds specific Jewel need in a Royale Application.
	 *
	 * This class extends the standard Application and sets up the
	 * SimpleCSSValuesImpl (implementation) for convenience.
	 *
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.2
	 */
	public class Application extends org.apache.royale.core.Application
	{
		/**
         *  constructor.
         *
		 * <inject_html>
		 * <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
     	 * </inject_html>
	 	 * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.2
         */
		public function Application()
		{
			super();
			
			this.valuesImpl = new SimpleCSSValuesImpl();

			// this a is temp solution until we get a better way to get a reference to Application
			//topLevelApplication = this;
		}

		/**
         *  static reference to this application used mainly for dialog (Dialog class)
		 * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.2
         */
        //public static var topLevelApplication:Object;
	}
}
