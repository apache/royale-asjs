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

goog.provide('org.apache.flex.maps.google.models.MapModel');

goog.require('org.apache.flex.core.IBeadModel');
goog.require('org.apache.flex.events.EventDispatcher');


// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.IBeadModel}
 */
org.apache.flex.maps.google.models.MapModel = function() {
  org.apache.flex.maps.google.models.MapModel.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.maps.google.models.MapModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.maps.google.models.MapModel.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'MapModel',
           qName: 'org.apache.flex.maps.google.models.MapModel' }],
    interfaces: [org.apache.flex.core.IBeadModel] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.maps.google.models.MapModel.prototype.
    set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @expose
 * @return {Array} The search results list.
 */
org.apache.flex.maps.google.models.MapModel.prototype.get_searchResults =
function() {
  return this._searchResults;
};


/**
 * @expose
 * @param {Array} value A list of search results.
 */
org.apache.flex.maps.google.models.MapModel.prototype.set_searchResults =
function(value) {
  this._searchResults = value;
  this.dispatchEvent('searchResultsChanged');
};


/**
 * @expose
 * @return {Number} Map zoom level.
 */
org.apache.flex.maps.google.models.MapModel.prototype.get_zoom =
function() {
  return this._zoom;
};


/**
 * @expose
 * @param {Number} value Map zoom level.
 */
org.apache.flex.maps.google.models.MapModel.prototype.set_zoom =
function(value) {
  this._zoom = value;
  this.dispatchEvent('zoomChanged');
};


/**
 * @expose
 * @return {Object} The currently selected map Marker.
 */
org.apache.flex.maps.google.models.MapModel.prototype.get_selectedMarker =
function() {
  return this._selectedMarker;
};


/**
 * @expose
 * @param {Object} value A marker to be made the selected marker.
 */
org.apache.flex.maps.google.models.MapModel.prototype.set_selectedMarker =
function(value) {
  this._selectedMarker = value;
  this.dispatchEvent('selectedMarkerChanged');
};


/**
 * @expose
 * @return {Object} The map's current center.
 */
org.apache.flex.maps.google.models.MapModel.prototype.get_currentLocation =
function() {
  return this._currentLocation;
};


/**
 * @expose
 * @param {Object} value The map's new current center.
 */
org.apache.flex.maps.google.models.MapModel.prototype.set_currentLocation =
function(value) {
  this._currentLocation = value;
  this.dispatchEvent('currentLocationChanged');
};
