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
package org.apache.royale.textLayout.elements
{

	
	/**
	 *  The LinkState class defines a set of constants for the <code>linkState</code> property
	 *  of the LinkElement class. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 *  @see LinkElement#linkState
	 */
	 
 	public final class LinkState {
 	
	/** 
	 * Value for the normal, default link state. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
    	public static const LINK:String = "link";
    
	/** 
	 * Value for the hover state, which occurs when you drag the mouse over a link. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */ 
	 
    	public static const HOVER:String = "hover";
    
	/** 
	 * Value for the active state, which occurs when you hold the mouse down over a link. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	 
    	public static const ACTIVE:String = "active";
		
		/** @private Used to turn the link specific formatting off temporarily for markerFormat computations */
		public static const SUPPRESSED:String = "supressed";
	}
}
