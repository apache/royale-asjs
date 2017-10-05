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
package org.apache.royale.textLayout.conversion
{
	// [ExcludeClass]
	/**
	 * @private  
	 */
	internal class SingletonAttributeImporter implements IFormatImporter
	{
		private var _keyToMatch:String;
		private var _rslt:String = null;
		
		public function SingletonAttributeImporter(key:String)
		{ _keyToMatch =  key; }
		public function reset():void
		{ _rslt = null; }
		public function get result():Object
		{ return _rslt; }
		public function importOneFormat(key:String,val:String):Boolean
		{
			if (key == _keyToMatch)
			{
				_rslt = val;
				return true;
			}
			return false; 
		}
	}
}
