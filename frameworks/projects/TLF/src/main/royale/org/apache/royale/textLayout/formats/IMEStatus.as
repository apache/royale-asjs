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
package org.apache.royale.textLayout.formats
{
	// [ExcludeClass]
	/**
	 *  Used internally for specifying the status of clauses in IME text during an IME text entry session.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public final class IMEStatus
	{
		public function IMEStatus()
		{
		}
		
		/** The name of the IMEClause property. Value is an integer.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const IME_CLAUSE:String = "imeClause";
		
		/** The name of the IMEStatus property
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const IME_STATUS:String = "imeStatus";
		
		// Following are all the possible values of imeStatus property:
		
		/** Selected raw - text has not been converted and is the current clause in the IME session
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const SELECTED_RAW:String = "selectedRaw";

		/** Selected coverted - text has been converted and is the current clause in the IME session
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const SELECTED_CONVERTED:String = "selectedConverted";

		/** Not selected raw - text has not been converted and is not part of the current clause 
		 *  in the IME session
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const NOT_SELECTED_RAW:String = "notSelectedRaw";
		
		/** Not selected converted - text has been converted and is not part of the current clause 
		 * 	in the IME session
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const NOT_SELECTED_CONVERTED:String = "notSelectedConverted";

		/** Dead key input state - in the process of entering a multi-key character, such as an accented char
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const DEAD_KEY_INPUT_STATE:String = "deadKeyInputState";

	}
}
