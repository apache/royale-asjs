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

package mx.managers
{
	
	/**
	 *  The CursorManagerPriority class defines the constant values for the 
	 *  <code>priority</code> argument to the 
	 *  <code>CursorManager.setCursor()</code> method. 
	 *
	 *  @see mx.managers.CursorManager
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public final class CursorManagerPriority
	{
		//include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constant that specifies the highest cursor priority when passed
		 *  as the <code>priority</code> argument to <code>setCursor()</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const HIGH:int = 1;
		
		/**
		 *  Constant that specifies a medium cursor priority when passed 
		 *  as the <code>priority</code> argument to <code>setCursor()</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const MEDIUM:int = 2;
		
		/**
		 *  Constant that specifies the lowest cursor priority when passed
		 *  as the <code>priority</code> argument to <code>setCursor()</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const LOW:int = 3;
		
		
	}
	
}
