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

goog.provide('org.apache.flex.maps.google.Marker');

goog.require('org.apache.flex.maps.google.LatLng');



// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 */
org.apache.flex.maps.google.Marker = function() {
  this.position = new org.apache.flex.maps.google.LatLng();
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.maps.google.Marker.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'Marker',
           qName: 'org.apache.flex.maps.google.Marker' }],
    interfaces: [] };


/**
 * @type {Object} The marker's location.
 */
org.apache.flex.maps.google.Marker.prototype.position = null;


/**
 * @type {String} The title for the marker.
 */
org.apache.flex.maps.google.Marker.prototype.title = null;


/**
 * @type {Object} The map to which the marker belongs.
 */
org.apache.flex.maps.google.Marker.prototype.map = null;

