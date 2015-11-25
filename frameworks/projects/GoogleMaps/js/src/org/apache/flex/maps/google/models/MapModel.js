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


Object.defineProperties(org.apache.flex.maps.google.models.MapModel.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        set: function(value) {
           this.strand_ = value;
        }
    },
    /** @export */
    searchResults: {
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        get: function() {
            return this._searchResults;
        },
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        set: function(value) {
            this._searchResults = value;
            this.dispatchEvent('searchResultsChanged');
        }
    },
    /** @export */
    zoom: {
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        get: function() {
            return this._zoom;
        },
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        set: function(value) {
            this._zoom = value;
            this.dispatchEvent('zoomChanged');
        }
    },
    /** @export */
    selectedMarker: {
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        get: function() {
            return this._selectedMarker;
        },
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        set: function(value) {
            this._selectedMarker = value;
            this.dispatchEvent('selectedMarkerChanged');
        }
    },
    /** @export */
    currentLocation: {
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        get: function() {
            return this._currentLocation;
        },
        /** @this {org.apache.flex.maps.google.models.MapModel} */
        set: function(value) {
            this._currentLocation = value;
            this.dispatchEvent('currentLocationChanged');
        }
    }
});
