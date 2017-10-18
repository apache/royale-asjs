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
package org.apache.royale.maps.google.beads
{
	COMPILE::SWF {
		import flash.events.Event;
		import flash.net.URLRequest;
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		
		import org.apache.royale.utils.HTMLLoader;
	}

    import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.maps.google.GoogleMap;
	import org.apache.royale.maps.google.models.MapModel;

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
	 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;

			var token:String = (_strand as GoogleMap).token;
			var src:String = 'https://maps.googleapis.com/maps/api/js?v=3.exp';
			if (token)
				src += '&key=' + token;
			src += '&libraries=geometry,places&callback=mapInit';

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
		 *  @productversion Royale 0.0
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
			IEventDispatcher(_strand).dispatchEvent(new Event('ready'));
		}

		/**
		 * Centers the map on the address given.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion google.maps.Marker
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 * @royaleignorecoercion google.maps.Marker
		 * @royaleignorecoercion google.maps.LatLng
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
		 * @royaleignorecoercion google.maps.Marker
		 * @royaleignorecoercion google.maps.LatLng
		 */
		public function markerClicked(marker:Marker):void
		{
			var newMarker:Marker = new Marker({
				position: marker["latLng"],
				title: marker["title"],
				map: realMap
			});

			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.selectedMarker = newMarker;

			var newEvent:Event = new Event('markerClicked');
			IEventDispatcher(_strand).dispatchEvent(newEvent);
		}

	} // end ::JS



	/**
	 * The AS3 version of GoogleMapView is geared toward its use with HTMLLoader
	 * for AIR.
	 */
	COMPILE::SWF
	public class GoogleMapView extends BeadViewBase implements IBeadView
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function GoogleMapView()
		{
			super();
		}

		private var _loader:HTMLLoader;
		private var page:String;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			_loader = new HTMLLoader();
			_loader.x = 0;
			_loader.y = 0;
			_loader.width = UIBase(value).width;
			_loader.height = UIBase(value).height;
			_loader.placeLoadStringContentInApplicationSandbox = false;

			IEventDispatcher(_strand).addEventListener("widthChanged",handleSizeChange);
			IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);

			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			model.addEventListener("zoomChanged", handleZoomChange);
			model.addEventListener("currentLocationChanged", handleCurrentLocationChange);

			(_strand as UIBase).addChild(_loader);

			var token:String = GoogleMap(_strand).token;
			if (token)
				page = pageTemplateStart + "&key=" + token + pageTemplateEnd;
			else
				page = pageTemplateStart + pageTemplateEnd;
			
			var pathToFile:String;
			
			if (page) {
				pathToFile = File.applicationDirectory.resolvePath('royale_mapapi.html').nativePath;
				var someFile:File = new File(pathToFile);
				var writeStream:FileStream = new FileStream();
				writeStream.open(someFile, FileMode.WRITE);
				writeStream.writeUTFBytes(page);
				writeStream.close();
			}
			
			_loader.load(new URLRequest("file://"+pathToFile));
			_loader.addEventListener(flash.events.Event.COMPLETE, completeHandler);
		}

		private function completeHandler(event:flash.events.Event):void
		{
			if (_loader && page) {
				_loader.window.map.center_changed = onMapCentered;
				_loader.window.map.bounds_changed = onMapBoundsChanged;
				_loader.window.map.zoom_changed   = onMapZoomChanged;
				_loader.window.map.dragend        = onMapDragEnd;
				_loader.window.map.draggable      = true;

				// custom event handlers
				_loader.window.addEventListener("searchResults",onSearchResults);
				_loader.window.addEventListener("markerClicked",onMarkerClicked);
			}

			IEventDispatcher(_strand).dispatchEvent(new org.apache.royale.events.Event("ready"));
		}

		private function handleZoomChange(event:org.apache.royale.events.Event):void
		{
			if (_loader && page) {
				var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
				setZoom(model.zoom);
			}
		}

		private function handleCurrentLocationChange(event:org.apache.royale.events.Event):void
		{
			if (_loader && page) {
				var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
				setCenter(model.currentCenter);
			}
		}

		/**
		 * @private
		 */
		private function handleSizeChange(event:org.apache.royale.events.Event):void
		{
			_loader.width = UIBase(_strand).width;
			_loader.height = UIBase(_strand).height;
		}

		/**
		 * @private
		 */
		private function onMapCentered():void
		{
			IEventDispatcher(_strand).dispatchEvent( new org.apache.royale.events.Event("centered") );
		}

		/**
		 * @private
		 */
		private function onMapBoundsChanged():void
		{
			IEventDispatcher(_strand).dispatchEvent( new org.apache.royale.events.Event("boundsChanged") );
		}

		/**
		 * @private
		 */
		private function onMapZoomChanged():void
		{
			IEventDispatcher(_strand).dispatchEvent( new org.apache.royale.events.Event("zoomChanged") );
		}

		/**
		 * @private
		 */
		private function onMapDragEnd():void
		{
			IEventDispatcher(_strand).dispatchEvent( new org.apache.royale.events.Event("dragEnd") );
		}

		/**
		 * @private
		 */
		private function onSearchResults(event:*):void
		{
			var results:Array = [];
			for(var i:int=0; i < event.results.length; i++) {
				var place:Object = event.results[i];
				results.push(place);
			}

			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.searchResults = results;
		}

		/**
		 * @private
		 */
		private function onMarkerClicked(event:*):void
		{
			var marker:Marker = new Marker({
				position: event.marker.getPosition(),
				title: event.marker.getTitle(),
				map: event.marker.getMap()
			});

			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.selectedMarker = marker;

			IEventDispatcher(_strand).dispatchEvent(new org.apache.royale.events.Event("markerClicked"));
		}

		/**
		 *  Adjusts the map to the given coordinate and zoom level.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function mapit(lat:Number, lng:Number, zoomLevel:Number):void
		{
			if (_loader && page) {
				_loader.window.mapit(lat, lng, zoomLevel);
			}
		}

		/**
		 *  Finds the given address and places a marker on it. This function may be dropped
		 *  since centerOnAddress + markCurrentLocation does the same thing.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function markAddress(address:String):void
		{
			if (_loader && page) {
				_loader.window.codeaddress(address);
			}
		}

		/**
		 * Centers the map on the address given.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function centerOnAddress(address:String):void
		{
			if (_loader && page) {
				_loader.window.centeronaddress(address);
			}
		}

		/**
		 * Marks the current center of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function markCurrentLocation():void
		{
			if (_loader && page) {
				_loader.window.markcurrentlocation();
			}
		}

		/**
		 * Performs a search near the center of map. The result is a set of
		 * markers displayed on the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function nearbySearch(placeName:String):void
		{
			if (_loader && page) {
				_loader.window.nearbysearch(placeName);
			}
		}

		/**
		 * Creates a marker for placement on the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
		 */
		public function removeAllMarkers():void
		{
			if (_loader && page) {
				_loader.window.clearmarkers();
			}
		}

		/**
		 * Sets the zoom factor of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function setZoom(zoom:Number):void
		{
			if (_loader && page) {
				_loader.window.map.setZoom(zoom);
			}
		}

		/**
		 * Sets the center of the map.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function setCenter( location:LatLng ):void
		{
			if (_loader && page) {
				_loader.window.setCenter(location.lat, location.lng);
			}
		}

		/**
		 * Clears the previous search results.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function clearSearchResults():void
		{
			// not implemented
		}

		/**
		 * @private
		 * This page definition is used with HTMLLoader to bring in the Google Maps
		 * API (a Google APP token is required).
		 */
		private static var pageTemplateStart:String = '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">\n'+
			'<html>\n'+
			'  <head>\n'+
			'    <style type="text/css">\n'+
			'      html { height: 100%; }\n'+
			'      body { height: 100%; margin: 0; padding: 0; background-color: #FFFFCC; }\n'+
			'      #map-canvas { height: 100% }\n'+
			'    </style>\n'+
			'    <script type="text/javascript"'+
			'      src="https://maps.googleapis.com/maps/api/js?v=3.exp';

		private static var pageTemplateEnd:String = '&libraries=places">'+
			'    </script>\n'+
			'    <script type="text/javascript">\n'+
			'      var map;'+
			'      var geocoder;'+
			'      var currentCenter;' +
			'      var service;' +
			'      var places;' +
			'      var markers;'+
			'      function mapit(lat, lng, zoomLevel) {' +
			'        currentCenter = new google.maps.LatLng(lat, lng);'+
			'        if (map == null) {' +
			'            var mapOptions = {'+
			'              center: currentCenter,'+
			'              zoom: zoomLevel'+
			'            };'+
			'            map = new google.maps.Map(document.getElementById("map-canvas"),'+
			'              mapOptions);' +
			'        }' +
			'        google.maps.event.addListener(map, "center_changed", function() {' +
			'            currentCenter = map.getCenter();' +
			'        });' +
			'        google.maps.event.addListener(map, "bounds_changed", function() {' +
			'            currentCenter = map.getCenter();' +
			'        });' +
			'        map.setCenter(currentCenter);'+
			'      };' +
			'      function setCenter(lat, lng) {' +
			'          currentCenter = new google.maps.LatLng(lat,lng);' +
			'          map.setCenter(currentCenter);' +
			'      };'+
			'      function codeaddress(address) {'+
			'        if (!geocoder) geocoder = new google.maps.Geocoder();'+
		    '        geocoder.geocode( { "address": address}, function(results, status) {'+
			'           if (status == google.maps.GeocoderStatus.OK) {'+
			'             currentCenter = results[0].geometry.location;'+
			'             map.setCenter(currentCenter);'+
			'             var marker = new google.maps.Marker({'+
			'                map: map,'+
			'                position: currentCenter,'+
			'            });'+
			'            } else {'+
			'                alert("Geocode was not successful for the following reason: " + status);'+
			'            }'+
			'        });'+
		    '      };'+
			'      function centeronaddress(address) {'+
			'        if (!geocoder) geocoder = new google.maps.Geocoder();'+
			'        geocoder.geocode( { "address": address}, function(results, status) {'+
			'          if (status == google.maps.GeocoderStatus.OK) {'+
			'             currentCenter = results[0].geometry.location;'+
			'             map.setCenter(currentCenter);' +
			'          } else {'+
			'                alert("Geocode was not successful for the following reason: " + status);'+
			'          }'+
			'        });'+
			'      };'+
			'      function markcurrentlocation() {'+
			'         createMarker(currentCenter);'+
			'      };' +
			'      function createMarker(location) {' +
			'         var marker = new google.maps.Marker({'+
			'            map: map,'+
			'            position: location,'+
			'         });' +
			'         google.maps.event.addListener(marker, "click", function() {' +
			'             markerClicked(marker);' +
			'         });'+
			'         return marker;'+
			'      };' +
			'      function clearmarkers() {' +
			'        if (markers) {' +
			'          for(var i=0; i < markers.length; i++) {' +
			'             markers[i].setMap(null);' +
			'          }' +
			'          markers = null;' +
			'        }' +
			'      };'+
			'      function nearbysearch(placename) {' +
			'         if (markers == null) markers = [];' +
			'         service = new google.maps.places.PlacesService(map);'+
		    '         service.nearbySearch({"location": currentCenter,' +
			'           "radius": 5000,' +
			'           "name": placename}, function(results, status) {' +
			'              places = results;' +
			'              if (status == google.maps.places.PlacesServiceStatus.OK) {' +
			'                 for(var i=0; i < results.length; i++) {' +
			'                    var place = results[i];' +
			'                    var marker = createMarker(place.geometry.location);' +
			'                    marker.title = place.name;' +
			'                    markers.push(marker);' +
			'                 }' +
			'                 var event = document.createEvent("Event");' +
			'                 event.results = places;'+
            '                 event.initEvent("searchResults", true, true);' +
			'                 window.dispatchEvent(event);' +
			'              }' +
			'          });'+
			'      };' +
			'      function markerClicked(marker) {' +
			'         var newEvent = document.createEvent("Event");' +
			'         newEvent.marker = marker;' +
			'         newEvent.initEvent("markerClicked", true, true);' +
			'         window.dispatchEvent(newEvent);' +
			'      };'+
			'      function initialize() {'+
			'        mapit(37.333, -121.900, 12);'+
			'      };'+
			'      google.maps.event.addDomListener(window, "load", initialize);'+
			'    </script>\n'+
			'  </head>\n'+
			'  <body>\n'+
			'    <div id="map-canvas"></div>\n'+
			'  </body>\n'+
			'</html>';
	} // end ::AS3

}
