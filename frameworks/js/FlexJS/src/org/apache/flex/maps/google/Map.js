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

goog.provide('org.apache.flex.maps.google.Map');


// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.maps.google.Map = function() {
  goog.base(this);
  this.initialized = false;
};
goog.inherits(org.apache.flex.maps.google.Map,
    org.apache.flex.core.UIBase);


/**
 * @override
 * @protected
 * @return {Object} The actual element to be parented.
 */
org.apache.flex.maps.google.Map.prototype.createElement =
    function() {

  this.element = document.createElement('div');

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @expose
 * @param {String} value Google API dev token.
 */
org.apache.flex.maps.google.Map.prototype.set_token = function(value) {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?key=' + value + '&sensor=false' +
              '&callback=mapInit';
  window.mapView = this;
  window.mapInit = function() {
      this.mapView.finishInitalization();
    };
  document.body.appendChild(script);
};


/**
 */
org.apache.flex.maps.google.Map.prototype.finishInitalization = function() {
  this.initialized = true;
  this.dispatchEvent('ready');
};


/**
 * @expose
 * @param {Number} centerLat center latitude.
 * @param {Number} centerLong center longitude.
 * @param {Number} zoom zoom level.
 */
org.apache.flex.maps.google.Map.prototype.loadMap =
    function(centerLat, centerLong, zoom) {
  if (this.initialized) {
    var mapOptions = {
      center: new google.maps.LatLng(centerLat, centerLong),
      zoom: zoom
    };
    this.map = new google.maps.Map(this.element, mapOptions);
  }
};
