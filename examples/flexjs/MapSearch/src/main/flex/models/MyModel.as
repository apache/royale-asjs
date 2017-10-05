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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	
	public class MyModel extends EventDispatcher implements IBeadModel
	{
		public function MyModel()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _cities:Array = ["San Jose, CA", "Sydney", "NYC", "Mexico City", "London", "Rio de Janeiro"];
		
		[Bindable]
		public function get cities():Array
		{
			return _cities;
		}
		
		private var _coordinates:Array = [
			{lat:37.3, lng: -121.5},
			{lat:-33.86, lng:151.211},
			{lat:40.712, lng:-74.0059},
			{lat:19.26, lng:-99.03},
			{lat:51.4, lng:-0.1},
			{lat:-22.95, lng:-43.12}];
		public function get coordinates():Array
		{
			return _coordinates;
		}
		
		private var _searchResults:Array = [];
		
		[Bindable("searchResultsChanged")]
		public function get searchResults():Array
		{
			return _searchResults;
		}
		public function set searchResults(value:Array):void
		{
			_searchResults = value;
			dispatchEvent(new Event("searchResultsChanged"));
		}
	}
}
