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
package org.apache.royale.textLayout 
{	

	/** 
	 *  This class controls the backward-compatibility of the framework.
	 *  With every new release, some aspects of the framework are changed which can affect your application.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.0
	 */
	public class TextLayoutVersion 
	{		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/** 
		 *  The current released version of the Text Layout Framework, encoded as a uint.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 */
		public static const CURRENT_VERSION:uint = 0x03000000;
		
		/** 
		 *  The version number value of TLF 3.0,
		 *  encoded numerically as a <code>uint</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 */
		public static const VERSION_3_0:uint = 0x03000000;
		
		/** 
		 *  The version number value of TLF 2.0,
		 *  encoded numerically as a <code>uint</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 */
		public static const VERSION_2_0:uint = 0x02000000;
		
		/** 
		 *  The version number value of TLF 1.0,
		 *  encoded numerically as a <code>uint</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 */
		public static const VERSION_1_0:uint = 0x01000000;

		/** 
		 *  The version number value of TLF 1.1,
		 *  encoded numerically as a <code>uint</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 */
		public static const VERSION_1_1:uint = 0x01010000;
		
		/** @private
		 * Contains the current build number. 
		 * It is static and can be called with <code>TextLayoutVersion.BUILD_NUMBER</code>
		 * <p>String Format: "BuildNumber (Changelist)"</p>
		 */
		public static const BUILD_NUMBER:String = "31 (763429)";
		
		/** @private
		 * Contains the branch name. 
		 */
		public static const BRANCH:String = "main";
		
		/**
		 * @private 
		 */
		public static const AUDIT_ID:String = "<AdobeIP 0000486>";
		
		/**
		 * @private 
		 */
		public function dontStripAuditID():String
		{
			return AUDIT_ID;
		}

		/** @private
		 *  The version as a string of the form "X.X.X".
		 *  Converts the version number to a more
		 *  human-readable String version.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 */
		public static function getVersionString(version:uint):String
		{
			var major:uint = (version >> 24) & 0xFF;
			var minor:uint = (version >> 16) & 0xFF;
			var update:uint = version & 0xFFFF;
			
			return major.toString() + "." +
				minor.toString() + "." +
				update.toString();
		}

	}
	
}
