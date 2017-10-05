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

/**
 * NOTE
 *
 * THIS IS THE OLD MapView. The new one is GoogleMapView. This code exists to preserve
 * the AS/HTMLLoader version for use with AIR. Someday we will come back to this and make
 * it work again.
 */
package org.apache.royale.maps.google.beads
{
	COMPILE::SWF {
		import flash.events.Event;
		import flash.html.HTMLLoader;
		import flash.net.URLRequest;
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

	/**
	 *  The MapView bead class displays a Google Map using HTMLLoader.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::JS
	public class MapView_original extends BeadViewBase implements IBeadView
	{
		public function MapView_original()
		{
			super();
		}

		private var _strand:IStrand;

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;

			var token:String = (_strand as GoogleMap).token;
			var src:String = 'https://maps.googleapis.com/maps/api/js?v=3.exp';
			if (token)
				src += '&key=' + token;
			src += '&libraries=places&sensor=false&callback=mapInit';

			var script:HTMLScriptElement = document.createElement('script') as HTMLScriptElement;
			script.type = 'text/javascript';
			script.src = src;

/**			window.mapView = this;
			window['mapInit'] = function() {
				(this.mapView._strand as GoogleMap).finishInitialization();
			}
**/
			document.head.appendChild(script);
		}
	}

	COMPILE::SWF
	public class MapView_original extends BeadViewBase implements IBeadView
	{
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function MapView_original()
		{
		}

		private var _loader:HTMLLoader;

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

			IEventDispatcher(_strand).addEventListener("widthChanged",handleSizeChange);
			IEventDispatcher(_strand).addEventListener("heightChanged",handleSizeChange);

			var model:IBeadModel = _strand.getBeadByType(IBeadModel) as IBeadModel;
			model.addEventListener("zoomChanged", handleZoomChange);
			model.addEventListener("currentLocationChanged", handleCurrentLocationChange);

			(_strand as UIBase).addChild(_loader);

			var token:String = Map(_strand).token;
			if (token)
				page = pageTemplateStart + "&key=" + token + pageTemplateEnd;
			else
				page = pageTemplateStart + pageTemplateEnd;

			if (page) {
				_loader.loadString(page);
				_loader.addEventListener(flash.events.Event.COMPLETE, completeHandler);
			}
		}

		private function completeHandler(event:flash.events.Event):void
		{
			trace("htmlLoader complete");

			if (_loader && page) {
				_loader.window.map.center_changed = onMapCentered;
				_loader.window.map.bounds_changed = onMapBoundsChanged;
				_loader.window.map.zoom_changed   = onMapZoomChanged;
				_loader.window.map.dragend        = onMapDragEnd;

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
				setCenter(model.currentLocation.location);
			}
		}

		private var page:String;

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
				_loader.window.mapit(lat,lng,zoomLevel);
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
		public function geoCodeAndMarkAddress(address:String):void
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
				var result:Place = new Place();
				result.geometry.location.lat = event.results[i].geometry.location.lat();
				result.geometry.location.lng = event.results[i].geometry.location.lng();
				result.icon = event.results[i].icon;
				result.id = event.results[i].id;
				result.name = event.results[i].name;
				result.reference = event.results[i].reference;
				result.vicinity = event.results[i].vicinity;
				results.push(result);
			}

			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.searchResults = results;
		}

		/**
		 * @private
		 */
		private function onMarkerClicked(event:*):void
		{
			var marker:Marker = new Marker();
			marker.position.lat = event.marker.position.lat();
			marker.position.lng = event.marker.position.lng();
			marker.title = event.marker.title;
			marker.map = Map(_strand);

			var model:MapModel = _strand.getBeadByType(IBeadModel) as MapModel;
			model.selectedMarker = marker;

			IEventDispatcher(_strand).dispatchEvent(new org.apache.royale.events.Event("markerClicked"));
		}

		/**
		 * @private
		 * This page definition is used with HTMLLoader to bring in the Google Maps
		 * API (a Google APP token is required).
		 */
		private static var pageTemplateStart:String = '<!DOCTYPE html>'+
			'<html>'+
			'  <head>'+
			'    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />'+
			'    <style type="text/css">'+
			'      html { height: 100% }'+
			'      body { height: 100%; margin: 0; padding: 0 }'+
			'      #map-canvas { height: 100% }'+
			'    </style>'+
			'    <script type="text/javascript"'+
			'      src="https://maps.googleapis.com/maps/api/js?v=3.exp';

		private static var pageTemplateEnd:String = '&libraries=places&sensor=false">'+
			'    </script>'+
			'    <script type="text/javascript">'+
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
			'    </script>'+
			'  </head>'+
			'  <body>'+
			'    <div id="map-canvas"></div>'+
			'  </body>'+
			'</html>';
	}

}
