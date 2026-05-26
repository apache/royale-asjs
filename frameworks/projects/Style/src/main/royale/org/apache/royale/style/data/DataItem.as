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
package org.apache.royale.style.data
{
	/**
	 * A simple implementation of IDataItem that can be used as a base class for more complex data items or as a simple data item on its own.
	 * 
	 * @languageversion 3.0
	 * @productversion Royale 1.0.0
	 */
	public class DataItem implements IDataItem
	{
		public function DataItem()
		{

		}
		private var _disabled:Boolean;
		public function get disabled():Boolean{
			return _disabled;
		}
		public function set disabled(value:Boolean):void{
			_disabled = value;
		}
		private var _selected:Boolean;
		public function get selected():Boolean{
			return _selected;
		}
		public function set selected(value:Boolean):void{
			_selected = value;
		}
	}
}