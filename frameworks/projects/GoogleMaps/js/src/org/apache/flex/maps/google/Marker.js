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

goog.provide('org_apache_flex_maps_google_Marker');

goog.require('org_apache_flex_maps_google_LatLng');



// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 */
org_apache_flex_maps_google_Marker = function() {
  this.position = new org_apache_flex_maps_google_LatLng();
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_maps_google_Marker.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'Marker',
           qName: 'org_apache_flex_maps_google_Marker' }],
    interfaces: [] };


/**
 * @type {Object} The marker's location.
 */
org_apache_flex_maps_google_Marker.prototype.position = null;


/**
 * @type {String} The title for the marker.
 */
org_apache_flex_maps_google_Marker.prototype.title = null;


/**
 * @type {Object} The map to which the marker belongs.
 */
org_apache_flex_maps_google_Marker.prototype.map = null;

