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
package org.apache.royale.maps.google.models
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

	import google.maps.LatLng;
	import google.maps.Marker;

	/**
	 * The data model for the Map class, this holds the maps current center
	 * location, its current zoom level, the last marker selected, and any
	 * search results.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class MapModel extends EventDispatcher implements IBeadModel
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function MapModel()
		{
			super();
		}

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}

		private var _token:String;

		public function get token():String
		{
			return _token;
		}
		public function set token(value:String):void
		{
			_token = value;
			dispatchEvent(new Event("tokenChanged"));
		}

		private var _currentCenter:LatLng;

		/**
		 * The current center of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get currentCenter():LatLng
		{
			return _currentCenter;
		}

		public function set currentCenter(value:LatLng):void
		{
			_currentCenter = value;
			dispatchEvent( new Event("currentCenterChanged") );
		}

		private var _selectedMarker:Marker;

		/**
		 * The last marker selected, if any.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get selectedMarker():Marker
		{
			return _selectedMarker;
		}

		public function set selectedMarker(value:Marker):void
		{
			_selectedMarker = value;
			dispatchEvent( new Event("selectedMarkerChanged") );
		}

		private var _zoom:Number;

		/**
		 * The current zoom level.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get zoom():Number
		{
			return _zoom;
		}
		public function set zoom(value:Number):void
		{
			if (value != _zoom) {
				_zoom = value;
				dispatchEvent( new Event("zoomChanged") );
			}
		}

		private var _searchResults:Array;

		/**
		 * Results from the last search.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get searchResults():Array
		{
			return _searchResults;
		}
		public function set searchResults(value:Array):void
		{
			_searchResults = value;
			dispatchEvent( new Event("searchResultsChanged") );
		}
	}
}
