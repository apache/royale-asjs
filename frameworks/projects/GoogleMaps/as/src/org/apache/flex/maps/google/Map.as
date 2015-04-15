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
package org.apache.flex.maps.google
{
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.maps.google.beads.MapView;
	import org.apache.flex.maps.google.models.MapModel;
	
	[Event(name="ready", type="org.apache.flex.events.Event")]
	[Event(name="centered", type="org.apache.flex.events.Event")]
	[Event(name="boundsChanged", type="org.apache.flex.events.Event")]
	[Event(name="zoomChanged", type="org.apache.flex.events.Event")]
	[Event(name="dragEnd", type="org.apache.flex.events.Event")]
	[Event(name="searchResult", type="org.apache.flex.events.Event")]
	
	/**
	 *  The Map class displays a Google Map centered on lat/lng coordinates. The Map uses
	 *  the following bead type:
	 * 
	 *  org.apache.flex.maps.beads.MapView: Uses HTMLLoader to display the map.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Map extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Map()
		{
			super();
			
			var model:IBeadModel = getBeadByType(IBeadModel) as IBeadModel;
			if (model == null) {
				model = new MapModel();
				addBead(model);
			}
		}
		
		private var _token:String;
		
		/**
		 *  The Google API developer token.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set token(value:String):void
		{
			_token = value; 
		}
		/**
		 * @private
		 */
		public function get token():String
		{
			return _token; 
		}
		
		public var searchResults:Array;
				
		/**
		 *  The marker last selected.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedMarker():Marker
		{
			return MapModel(model).selectedMarker;
		}
		
		/**
		 *  Loads a map centered on the given latitude and longitude coodinates at the
		 *  zoom level provided.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function loadMap( centerLat:Number, centerLong:Number, zoom:Number ) : void
		{
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead) {
				viewBead.mapit(centerLat, centerLong, zoom);
			}
		}
		
		/**
		 *  Sets the magnification level on the map with 1 being the lowest level
		 *  (essentially the entire world) and 14 being very zoomed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function setZoom( zoom:Number ) : void
		{
			MapModel(model).zoom = zoom;
		}
		
		/**
		 * Centers the map on the address given.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function centerOnAddress( address:String ) : void
		{
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead) {
				viewBead.centerOnAddress(address);
			}
		}
		
		/**
		 * Centers the map on a specific location.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function setCenter( location:LatLng ) : void
		{
			var geo:Geometry = new Geometry();
			geo.location = location;
			MapModel(model).currentLocation = geo;
		}
		
		/**
		 * Marks the current center of the map.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function markCurrentLocation() : void
		{
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead) {
				viewBead.markCurrentLocation();
			}
		}
		
		/**
		 * Performs a search near the center of map. The result is a set of
		 * markers displayed on the map.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function nearbySearch(placeName:String):void
		{
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead) {
				viewBead.nearbySearch(placeName);
			}
		}
		
		/**
		 * Clears the search result markers from the map.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function clearSearchResults():void
		{
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead) {
				viewBead.removeAllMarkers();
			}
			MapModel(model).searchResults = [];
		}
		
		/**
		 *  Translates the given address into a geo-location, moves the map to
		 *  that location, and places a marker on that location.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function markAddress( address:String ) : void
		{
			var viewBead:MapView = getBeadByType(IBeadView) as MapView;
			if (viewBead) {
				viewBead.geoCodeAndMarkAddress(address);
			}
		}
	}
}