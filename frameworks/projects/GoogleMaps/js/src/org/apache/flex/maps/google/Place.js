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

goog.provide('org.apache.flex.maps.google.Place');

goog.require('org.apache.flex.maps.google.Geometry');


// IMPORTANT:
// In order to use this class, the Google MAP API must be downloaded
// from the <head> section of the main HTML file.



/**
 * @constructor
 */
org.apache.flex.maps.google.Place = function() {
  this.geometry = new org.apache.flex.maps.google.Geometry();
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.maps.google.Place.prototype.
FLEXJS_CLASS_INFO =
{ names: [{ name: 'Place',
           qName: 'org.apache.flex.maps.google.Place' }],
    interfaces: [] };


/**
 * @type {Object} The current location
 */
org.apache.flex.maps.google.Place.prototype.geometry = null;


/**
 * @type {String} The icon representing the place.
 */
org.apache.flex.maps.google.Place.prototype.icon = null;


/**
 * @type {String} A unique identifier for the place.
 */
org.apache.flex.maps.google.Place.prototype.id = null;


/**
 * @type {String} The name of the place.
 */
org.apache.flex.maps.google.Place.prototype.name = null;


/**
 * @type {String} A reference identifier.
 */
org.apache.flex.maps.google.Place.prototype.reference = null;


/**
 * @type {String} A description of the area of the place.
 */
org.apache.flex.maps.google.Place.prototype.vicinity = null;


/**
 * @override
 * @return {string} A description of the area of the place.
 */
org.apache.flex.maps.google.Place.prototype.toString = function PlaceToString() {
  var results = '';
  if (this.name) results = this.name;
  if (this.vicinity) results += ' ' + this.vicinity;
  return results;
};

