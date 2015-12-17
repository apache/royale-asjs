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
package org.apache.flex.maps.google.beads
{
	COMPILE::AS3 {
		import flash.events.Event;
		import flash.html.HTMLLoader;
		import flash.net.URLRequest;
	}

    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.maps.google.GoogleMap;
	import org.apache.flex.maps.google.models.MapModel;

	COMPILE::JS {
		import goog.bind;
	}

	import google.maps.event;
	import google.maps.Geocoder;
	import google.maps.GeocoderResult;
	import google.maps.GeocoderStatus;
	import google.maps.LatLng;
	import google.maps.Map;
	import google.maps.Marker;
	import google.maps.places.PlaceResult;
	import google.maps.places.PlacesService;
	import google.maps.places.PlacesServiceStatus;

	/**
	 *  The MapView bead class displays a Google Map using HTMLLoader.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	COMPILE::JS
	public class GoogleMapView extends BeadViewBase implements IBeadView
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function GoogleMapView()
		{
			super();
		}

		private var realMap:Map;
		private var geocoder:Geocoder;
		private var initialized:Boolean = false;
		private var markers:Array;
		private var searchResults:Array;
		private var service:PlacesService;

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;

			var token:String = (_strand as GoogleMap).token;
			var src:String = 'https://maps.googleapis.com/maps/api/js?v=3.exp';
			if (token)
				src += '&key=' + token;
			src += '&libraries=geometry,places&sensor=false&callback=mapInit';

			var script:HTMLScriptElement = document.createElement('script') as HTMLScriptElement;
			script.type = 'text/javascript';
			script.src = src;

			window['mapView'] = this;
			window['mapInit'] = function():void {
				(this['mapView'] as GoogleMapView).finishInitialization();
			}

			document.head.appendChild(script);
		}

		/**
		 *  Adjusts the map to the given coordinate and zoom level.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function mapit( centerLat:Number, centerLng:Number, zoom:Number ):void
		{
			if (!initialized) {
				var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
				model.currentCenter = new LatLng(centerLat, centerLng);
				model.zoom = zoom;
				var mapOptions:Object = new Object();
				mapOptions['center'] = model.currentCenter;
				mapOptions['zoom'] = zoom;

				realMap = new Map((_strand as UIBase).element, mapOptions);
				geocoder = null;

			    model.addEventListener("zoomChanged", handleModelChange);

				google.maps.event.addListener(realMap, 'center_changed', goog.bind(centerChangeHandler, this));
				google.maps.event.addListener(realMap, 'bounds_changed', goog.bind(boundsChangeHandler, this));
				google.maps.event.addListener(realMap, 'zoom_changed',   goog.bind(zoomChangeHandler,   this));
			}
		}

		/**
		 * @private
		 */
		private function finishInitialization():void
		{
			mapit(37.333, -121.900, 12);
			initialized = true;
			dispatchEvent(new Event('ready'));
		}

		/**
		 * Centers the map on the address given.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function centerOnAddress(value:String):void
		{
			if (geocoder == null) geocoder = new Geocoder();
			geocoder.geocode({address:value}, positionHandler);
		}

		/**
		 * Sets the center of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function setCenter(location:LatLng):void
		{
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.currentCenter = new LatLng(location.lat(), location.lng());
			realMap.setCenter(model.currentCenter);
		}

		/**
		 * Marks the current center of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function markCurrentLocation():void
		{
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			createMarker(model.currentCenter as LatLng);
		}

		/**
		 *  Finds the given address and places a marker on it. This function may be dropped
		 *  since centerOnAddress + markCurrentLocation does the same thing.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function markAddress(address:String):void
		{
			if (initialized) {
				if (geocoder == null) geocoder = new Geocoder();
				geocoder.geocode({address:address}, geocodeHandler);
			}
		}

		/**
		 * Creates a marker for placement on the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 *  @flexjsignorecoercion google.maps.Marker
		 */
		public function createMarker(location:LatLng):Marker
		{
			var marker:Marker = new Marker({map:realMap, position:location});
		//	google.maps.event.addListener(marker, 'click', goog.bind(markerClicked, this));
		    marker.addListener('click', markerClicked);

			return marker;
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
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;

			if (markers == null) markers = [];
			service = new PlacesService(realMap);
			service.nearbySearch({location:model.currentCenter, radius:5000, name:placeName}, searchResultsHandler);
		}

		/**
		 * Clears the previous search results.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function clearSearchResults():void
		{
			if (markers) {
				for(var i:int=0; i < markers.length; i++) {
					var m:Marker = markers[i] as Marker;
					m.setMap(null);
				}
				markers = null;
			}
		}

		// Callbacks

		/**
		 * @private
		 */
		public function centerChangeHandler() : void
		{
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.currentCenter = realMap.getCenter();

			var newEvent:Event = new Event('centered');
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
		}

		/**
		 * @private
		 */
		public function boundsChangeHandler():void
		{
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.currentCenter = realMap.getCenter();

			var newEvent:Event = new Event('boundsChanged');
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
		}

		/**
		 * @private
		 */
		public function zoomChangeHandler():void
		{
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.currentCenter = realMap.getCenter();

			var newEvent:Event = new Event('zoomChanged');
			(_strand as IEventDispatcher).dispatchEvent(newEvent);
		}

		/**
		 * @private
		 */
		public function positionHandler(results:Array, status:String):void
		{
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			if (status == GeocoderStatus.OK) {
				model.currentCenter = results[0].geometry.location;
				realMap.setCenter(model.currentCenter);

				// dispatch an event to indicate the map has been centered
			}
		}

		/**
		 * @flexjsignorecoercion google.maps.Marker
		 * @flexjsignorecoercion google.maps.LatLng
		 */
		public function geocodeHandler(results:Array, status:String):void
		{
			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			if (status == GeocoderStatus.OK) {
				model.currentCenter = results[0].geometry.location;
				realMap.setCenter(model.currentCenter);

				var marker:Marker = new Marker({map:realMap, position:model.currentCenter});
			}
		}

		/**
		 * @private
		 */
		public function searchResultsHandler(results:Array, status:String):void
		{
			searchResults = [];
			if (status == PlacesServiceStatus.OK) {
				for(var i:int=0; i < results.length; i++) {
					/*var place:PlaceResult = new PlaceResult();
					place.geometry.location = new LatLng(results[i].geometry.location.lat(), results[i].geometry.location.lng());
					place.icon = results[i].icon;
					place.id = results[i].id;
					place.name = results[i].name;
					place.reference = results[i].reference;
					place.vicinity = results[i].vicinity;*/
					var place:Object = results[i];
					searchResults.push(place);

					var marker:Marker = createMarker(place.geometry.location);
					marker.setTitle(place.name);

					markers.push(marker);
				}
				var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
				model.searchResults = searchResults;
			}
		}

		// Event handlers

		/**
		 * Handles changes to properties of the MapModel. When this value is
		 * changed, the map itself has its zoom changed. This will trigger an
		 * event on the map that will be handled by functions above.
		 */
		public function handleModelChange(event:Event):void
		{
			if (event.type == "zoomChanged") {
				var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
				realMap.setZoom(model.zoom);
			}
		}

		/**
		 * @flexjsignorecoercion google.maps.Marker
		 * @flexjsignorecoercion google.maps.LatLng
		 */
		public function markerClicked(marker:Marker):void
		{
			var pos:LatLng = marker["latLng"] as LatLng;//marker.getPosition();

			for (var i:int=0; i < markers.length; i++) {
				var test:LatLng = marker.getPosition();
				if (test.lat() == pos.lat() && test.lng() == pos.lng()) {
					var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
					model.selectedMarker = markers[i];
					break;
				}
			}

			var newEvent:Event = new Event('markerClicked');
			dispatchEvent(newEvent);
		}

	} // end ::JS

	/**
	 * The AS3 version of GoogleMapView is geared toward its use with HTMLLoader
	 * for AIR.
	 */
	COMPILE::AS3
	public class GoogleMapView extends BeadViewBase implements IBeadView
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function GoogleMapView()
		{
			super();
		}

		private var _loader:HTMLLoader;

		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
		}

		/**
		 *  Adjusts the map to the given coordinate and zoom level.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function mapit(lat:Number, lng:Number, zoomLevel:Number):void
		{

		}

		/**
		 *  Finds the given address and places a marker on it. This function may be dropped
		 *  since centerOnAddress + markCurrentLocation does the same thing.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function markAddress(address:String):void
		{

		}

		/**
		 * Centers the map on the address given.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function centerOnAddress(address:String):void
		{

		}

		/**
		 * Marks the current center of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function markCurrentLocation():void
		{

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

		}

		/**
		 * Creates a marker for placement on the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function createMarker(location:LatLng):Marker
		{
			return null;
		}

		/**
		 * Removes all of the markers from the map
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function removeAllMarkers():void
		{

		}

		/**
		 * Sets the zoom factor of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function setZoom(zoom:Number):void
		{

		}

		/**
		 * Sets the center of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function setCenter( location:LatLng ):void
		{

		}

		/**
		 * Clears the previous search results.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function clearSearchResults():void
		{
			// not implemented
		}
	}

}
