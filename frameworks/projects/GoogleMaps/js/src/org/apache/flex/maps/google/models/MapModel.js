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

goog.provide('org_apache_flex_maps_google_models_MapModel');

goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_events_EventDispatcher');


// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @implements {org_apache_flex_core_IBeadModel}
 */
org_apache_flex_maps_google_models_MapModel = function() {
  org_apache_flex_maps_google_models_MapModel.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_maps_google_models_MapModel,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_maps_google_models_MapModel.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'MapModel',
           qName: 'org_apache_flex_maps_google_models_MapModel' }],
    interfaces: [org_apache_flex_core_IBeadModel] };


Object.defineProperties(org_apache_flex_maps_google_models_MapModelv.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_maps_google_models_MapModel} */
        set: function(value) {
           this.strand_ = value;
        }
    },
    /** @expose */
    searchResults: {
        get: function() {
            return this._searchResults;
        },
        set: function(value) {
            this._searchResults = value;
            this.dispatchEvent('searchResultsChanged');
        }
    },
    /** @expose */
    zoom: {
        get: function() {
            return this._zoom;
        },
        set: function(value) {
            this._zoom = value;
            this.dispatchEvent('zoomChanged');
        }
    },
    /** @expose */
    selectedMarker: {
        get: function() {
            return this._selectedMarker;
        },
        set: function(value) {
            this._selectedMarker = value;
            this.dispatchEvent('selectedMarkerChanged');
        }
    },
    /** @expose */
    currentLocation: {
        get: function() {
            return this._currentLocation;
        },
        set: function(value) {
            this._currentLocation = value;
            this.dispatchEvent('currentLocationChanged');
        }
    }
});
