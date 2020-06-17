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
    import org.apache.royale.core.StyledUIBase;
    
	/**
	 *  The SimpleLoader class is widget used to show some progressing.
     *  It could be while loading dome data, or waiting for interface to complete 
     *  some task.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class SimpleLoader extends StyledUIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function SimpleLoader()
		{
			super();

            typeNames = "jewel loader segment";
			
		}
		
		public function start():void
		{
			COMPILE::JS
			{
			var timing:Object =  new Object();
			timing["duration"] = 1000;
			timing["iterations"] = Infinity;
			element["animate"]([{ transform: "rotate(0deg)"},{ transform: "rotate(360deg)"}], timing);
			}
		}
    }
}