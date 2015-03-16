/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_maps_google_Map');

goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_maps_google_Geometry');
goog.require('org_apache_flex_maps_google_LatLng');
goog.require('org_apache_flex_maps_google_Marker');
goog.require('org_apache_flex_maps_google_Place');
goog.require('org_apache_flex_maps_google_models_MapModel');


// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_maps_google_Map = function() {
  org_apache_flex_maps_google_Map.base(this, 'constructor');
  this.initialized = false;
};
goog.inherits(org_apache_flex_maps_google_Map,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_maps_google_Map.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'Map',
           qName: 'org_apache_flex_maps_google_Map' }],
    interfaces: [] };


/**
 *
 */
org_apache_flex_maps_google_Map.prototype.searchResults = null;


/**
 * @override
 * @protected
 * @return {Object} The actual element to be parented.
 */
org_apache_flex_maps_google_Map.prototype.createElement =
    function() {

  var model = new org_apache_flex_maps_google_models_MapModel();
  this.addBead(model);

  this.element = document.createElement('div');
  this.className = 'Map';

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


Object.defineProperties(org_apache_flex_maps_google_Map.prototype, {
    'token': {
 		/** @this {org_apache_flex_maps_google_Map} */
        set: function(value) {
            this.token = value;
        }
    },
    'selectedMarker': {
 		/** @this {org_apache_flex_maps_google_Map} */
        get: function() {
            return this._selectedMarker;
        }
    }
});


/**
 */
org_apache_flex_maps_google_Map.prototype.finishInitalization = function() {
  this.loadMap(37.333, -121.900, 12);
  this.initialized = true;
  this.dispatchEvent('ready');
};


/**
 * @expose
 * @param {number} centerLat center latitude.
 * @param {number} centerLong center longitude.
 * @param {number} zoom zoom level.
 */
org_apache_flex_maps_google_Map.prototype.loadMap =
    function(centerLat, centerLong, zoom) {
  if (!this.initialized) {
    this.currentCenter = new window['google']['maps']['LatLng'](centerLat, centerLong);
    var mapOptions = {};
    mapOptions['center'] = this.currentCenter;
    mapOptions['zoom'] = zoom;
    this.map = new window['google']['maps']['Map'](this.element, mapOptions);
    this.geocoder = null;
    google.maps.event.addListener(this.map, 'center_changed', goog.bind(this.centerChangeHandler, this));
    google.maps.event.addListener(this.map, 'bounds_changed', goog.bind(this.boundsChangeHandler, this));
    google.maps.event.addListener(this.map, 'zoom_changed', goog.bind(this.zoomChangeHandler, this));
  }
};


/**
 * @expose
 * @param {Number} zoomLevel The level of magnification.
 */
org_apache_flex_maps_google_Map.prototype.setZoom =
    function(zoomLevel) {
  if (this.initialized) {
    this.map.setZoom(zoomLevel);
  }
};


/**
 * @expose
 * @param {string} address The new center of the map.
 */
org_apache_flex_maps_google_Map.prototype.centerOnAddress = function(address) {
  if (!this.geocoder) this.geocoder = new window['google']['maps']['Geocoder']();
  this.geocoder.geocode({ 'address': address}, goog.bind(this.positionHandler, this));
};


/**
 * @expose
 * @param {Object} location The new center of the map.
 */
org_apache_flex_maps_google_Map.prototype.setCenter = function(location) {
  this.currentCenter = new window['google']['maps']['LatLng'](location.lat, location.lng);
  this.map.setCenter(this.currentCenter);
};


/**
 * @expose
 */
org_apache_flex_maps_google_Map.prototype.markCurrentLocation = function() {
  this.createMarker(this.currentCenter);
};


/**
 * @expose
 * @param {string} address The address to locate and mark on the map.
 */
org_apache_flex_maps_google_Map.prototype.markAddress =
    function(address) {
  if (this.initialized) {
    if (!this.geocoder) this.geocoder = new window['google']['maps']['Geocoder']();
    this.geocoder.geocode({ 'address': address}, goog.bind(this.geoCodeHandler, this));
  }
};


/**
 * @expose
 * @param {Object} location A LatLng that denotes the position of the marker.
 * @return {Object} A marker object.
 */
org_apache_flex_maps_google_Map.prototype.createMarker =
    function(location) {
  var marker = new window['google']['maps']['Marker']({
    map: this.map,
    position: location
  });
  google.maps.event.addListener(marker, 'click', goog.bind(this.markerClicked, this, marker));
  return marker;
};


/**
 * @expose
 * @param {string} placeName A place to search for.
 */
org_apache_flex_maps_google_Map.prototype.nearbySearch =
    function(placeName) {
  if (this.markers == null) this.markers = [];
  this.service = new window['google']['maps']['places']['PlacesService'](this.map);
  this.service.nearbySearch({'location': this.currentCenter,
    'radius': 5000,
    'name': placeName}, goog.bind(this.searchResultHandler, this));
};


/**
 * @expose
 */
org_apache_flex_maps_google_Map.prototype.clearSearchResults =
function() {
  if (this.markers) {
    for (var i = 0; i < this.markers.length; i++) {
      this.markers[i]['setMap'](null);
    }
    this.markers = null;
  }
};


/**
 * @param {Object} marker The marker that was clicked.
 * @param {Object} event The mouse event for the marker click.
 */
org_apache_flex_maps_google_Map.prototype.markerClicked =
function(marker, event) {
  var newMarker = new org_apache_flex_maps_google_Marker();
  newMarker.position.lat = marker.position.lat();
  newMarker.position.lng = marker.position.lng();
  newMarker.title = marker.title;
  newMarker.map = this;

  this._selectedMarker = newMarker;

  var newEvent = new org_apache_flex_events_Event('markerClicked');
  newEvent.marker = newMarker;
  this.dispatchEvent(newEvent);
};


/**
 * @param {Array} results The found location(s).
 * @param {string} status Status of the call.
 */
org_apache_flex_maps_google_Map.prototype.positionHandler =
    function(results, status) {
  if (status == window['google']['maps']['GeocoderStatus']['OK']) {
    this.currentCenter = results[0]['geometry']['location'];
    this.map['setCenter'](this.currentCenter);

    var newEvent = document.createEvent('Event');
    newEvent.initEvent('mapCentered', true, true);
    window.dispatchEvent(newEvent);
  } else {
    alert('Geocode was not successful for the following reason: ' + status);
  }
};


/**
 * @param {Array} results The found location(s).
 * @param {string} status Status of the call.
 */
org_apache_flex_maps_google_Map.prototype.geoCodeHandler =
    function(results, status) {
  if (status == window['google']['maps']['GeocoderStatus']['OK']) {
    this.currentCenter = results[0]['geometry']['location'];
    this.map['setCenter'](this.currentCenter);
    var marker = new window['google']['maps']['Marker']({
      map: this.map,
      position: this.currentCenter
    });
  } else {
    alert('Geocode was not successful for the following reason: ' + status);
  }
};


/**
 * @param {Array} results The result of the search.
 * @param {string} status Status of the search.
 */
org_apache_flex_maps_google_Map.prototype.searchResultHandler =
function(results, status) {
  this.searchResults = [];
  if (status == window['google']['maps']['places']['PlacesServiceStatus']['OK']) {
    for (var i = 0; i < results.length; i++) {
      var place = new org_apache_flex_maps_google_Place();
      place.geometry.location.lat = results[i]['geometry']['location']['lat'];
      place.geometry.location.lng = results[i]['geometry']['location']['lng'];
      place.icon = results[i]['icon'];
      place.id = results[i]['id'];
      place.name = results[i]['name'];
      place.reference = results[i]['reference'];
      place.vicinity = results[i]['vicinity'];
      this.searchResults.push(place);

      var marker = this.createMarker(results[i]['geometry']['location']);
      marker.title = place.name;

      this.markers.push(marker);
    }
    var model = this.model;
    model.searchResults = this.searchResults;
  }
};


/**
 * Handles changes in map center
 */
org_apache_flex_maps_google_Map.prototype.centerChangeHandler =
    function() {
  this.currentCenter = this.map['getCenter']();

  var newEvent = new org_apache_flex_events_Event('centered');
  this.dispatchEvent(newEvent);
};


/**
 * Handles changes in map bounds
 */
org_apache_flex_maps_google_Map.prototype.boundsChangeHandler =
    function() {
  this.currentCenter = this.map['getCenter']();

  var newEvent = new org_apache_flex_events_Event('boundsChanged');
  this.dispatchEvent(newEvent);
};


/**
 * Handles changes in map bounds
 */
org_apache_flex_maps_google_Map.prototype.zoomChangeHandler =
    function() {
  this.currentCenter = this.map['getCenter']();

  var newEvent = new org_apache_flex_events_Event('zoomChanged');
  this.dispatchEvent(newEvent);
};
