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

goog.provide('org_apache_flex_maps_google_Geometry');

goog.require('org_apache_flex_maps_google_LatLng');


// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 */
org_apache_flex_maps_google_Geometry = function() {
  this.location = new org_apache_flex_maps_google_LatLng();
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_maps_google_Geometry.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'Geometry',
           qName: 'org_apache_flex_maps_google_Geometry' }],
    interfaces: [] };


/**
 * @type {Object} The current location
 */
org_apache_flex_maps_google_Geometry.prototype.location = null;

