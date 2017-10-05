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
package org.apache.royale.maps.google
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.maps.google.beads.GoogleMapView;
	import org.apache.royale.maps.google.models.MapModel;

	import google.maps.LatLng;
	import google.maps.Marker;

	[Event(name="ready", type="org.apache.royale.events.Event")]
	[Event(name="centered", type="org.apache.royale.events.Event")]
	[Event(name="boundsChanged", type="org.apache.royale.events.Event")]
	[Event(name="zoomChanged", type="org.apache.royale.events.Event")]
	[Event(name="dragEnd", type="org.apache.royale.events.Event")]
	[Event(name="searchResult", type="org.apache.royale.events.Event")]
	[Event(name="markerClicked", type="org.apache.royale.events.MouseEvent")]

	/**
	 *  The Map class displays a Google Map centered on lat/lng coordinates. The Map uses
	 *  the following bead type:
	 *
	 *  org.apache.royale.maps.beads.MapView: Uses HTMLLoader to display the map.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 *  @royaleignoreimport goog.bind
	 *  @royaleignoreimport google.maps.event
	 */
	public class GoogleMap extends UIBase
	{

		public function GoogleMap()
		{
			super();

			className = "Map";

			var model:IBeadModel = getBeadByType(IBeadModel) as IBeadModel;
			if (model == null) {
				model = new MapModel();
				addBead(model);
			}
		}

		public function get token():String
		{
			return MapModel(model).token;
		}
		public function set token(value:String):void
		{
			MapModel(model).token = value;
		}

		public function get selectedMarker():Marker
		{
			return MapModel(model).selectedMarker;
		}

		public function get searchResults():Array
		{
			return MapModel(model).searchResults;
		}

		public function loadMap( centerLat:Number, centerLong:Number, zoom:Number ) : void
		{
			GoogleMapView(view).mapit(centerLat, centerLong, zoom);
		}

		public function setZoom(zoomLevel:Number):void
		{
			MapModel(model).zoom = zoomLevel;
		}

		public function centerOnAddress(address:String):void
		{
			GoogleMapView(view).centerOnAddress(address);
		}

		public function setCenter(location:LatLng):void
		{
			GoogleMapView(view).setCenter(location);
		}

		public function markCurrentLocation():void
		{
			GoogleMapView(view).markCurrentLocation();
		}

		public function markAddress(address:String):void
		{
			GoogleMapView(view).markAddress(address);
		}

		public function createMarker(location:LatLng):Marker
		{
			return GoogleMapView(view).createMarker(location);
		}

		public function nearbySearch(placeName:String):void
		{
			GoogleMapView(view).nearbySearch(placeName);
		}

		public function clearSearchResults():void
		{
			GoogleMapView(view).clearSearchResults();
		}
	}
}
