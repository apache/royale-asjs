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
package org.apache.royale.textLayout.elements {
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	


	// [ExcludeClass]
	/** This class extends TextLayoutFormat and add capabilities to hold privateData and userStyles.  @private */
	public class FlowValueHolder extends TextLayoutFormat
	{
		private var _privateData:Object;
		
		public function FlowValueHolder(initialValues:FlowValueHolder = null)
		{
			super(initialValues);
			initialize(initialValues);
		}
		
		private function initialize(initialValues:FlowValueHolder):void
		{
			if (initialValues)
			{
				var s:String;
				for (s in initialValues.privateData)
					setPrivateData(s, initialValues.privateData[s]);
			}
		}


		public function get privateData():Object
		{ return _privateData; }
		public function set privateData(val:Object):void
		{ _privateData = val; }

		public function getPrivateData(styleProp:String):*
		{ return _privateData ? _privateData[styleProp] : undefined; }

		public function setPrivateData(styleProp:String,newValue:*):void
		{
			if (newValue === undefined)
			{
				if (_privateData)
					delete _privateData[styleProp];
			}
			else
			{
				if (_privateData == null)
					_privateData = {};
				_privateData[styleProp] = newValue;
			}
		}
	}
}
