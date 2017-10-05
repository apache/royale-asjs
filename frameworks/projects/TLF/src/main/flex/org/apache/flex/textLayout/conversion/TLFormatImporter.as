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
	import org.apache.royale.textLayout.property.Property;
	import org.apache.royale.textLayout.debug.assert;
	// [ExcludeClass]
	/**
	 * @private  
	 */
	public class TLFormatImporter implements IFormatImporter
	{
		private var _classType:Class;
		private var _description:Object;
		
		private var _rslt:Object;
		
		public function TLFormatImporter(classType:Class,description:Object)
		{ 
			_classType = classType;
			_description = description;
		}
		
		public function get classType():Class
		{ return _classType; }
				
		public function reset():void
		{ 
			_rslt = null;
		}
		public function get result():Object
		{ 
			return _rslt; 
		}
		public function importOneFormat(key:String,val:String):Boolean
		{ 
			if (_description.hasOwnProperty(key))
			{
				if (_rslt == null)
					_rslt = new _classType();
	
				CONFIG::debug { assert((_description[key] as Property) != null,"Bad description in TLFormatImporter"); }
				_rslt[key] =  _description[key].setHelper(undefined,val);
				return true;
			}
			return false; 
		}
	}
}
