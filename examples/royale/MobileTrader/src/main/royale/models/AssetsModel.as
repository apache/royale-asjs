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
package models
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.collections.ArrayList;

	public class AssetsModel extends EventDispatcher implements IBeadModel
	{
		public function AssetsModel()
		{
			super();
			_assetsData = new ArrayList();
			_assetsData.source = source;
		}
		private var source:Array = [
			new Asset("NetWorth:", 161984, 2.36),
			new Asset("Last Month:", 165915, 10.98),
			new Asset("6 Months Ago:", 145962, 16.56),
			new Asset("Last Year:", 138972, 8.36)
		];
		private var _assetsData:ArrayList;

		public function get assetsData():ArrayList
		{
			return _assetsData;
		}

		public function get assetsDataAsArray():Array
		{
		    return source;
		}

		public function set strand(value:IStrand):void
		{
			// not used
		}
	}
}
