/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.display
{
	
	/**
	 * @royalesuppressexport
	 * These constants will be inlined in javascript
	 */
	public class LineScaleMode
	{
		/**
		 * With this setting used as the scaleMode parameter of the lineStyle() method, the thickness of the line scales only horizontally.
		 */
		public static const HORIZONTAL:String = "horizontal";
		
		/**
		 * With this setting used as the scaleMode parameter of the lineStyle() method, the thickness of the line never scales.
		 */
		public static const NONE:String = "none";
		
		/**
		 * With this setting used as the scaleMode parameter of the lineStyle() method,
		 * the thickness of the line always scales when the object is scaled (the default).
		 */
		public static const NORMAL:String = "normal";
		
		/**
		 * With this setting used as the scaleMode parameter of the lineStyle() method, the thickness of the line scales only vertically.
		 */
		public static const VERTICAL:String = "vertical";
    }
	
}


