/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.geom.Point');



/**
 * @constructor
 * @param {number} x
 * @param {number} y
 */
org.apache.flex.geom.Point = function(x, y) {

  this.x = x;

  this.y = y;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.geom.Point.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Point',
                qName: 'org.apache.flex.geom.Point'}] };


/**
 * @export
 * The x coordinate.
 * @type {number} value The x coordinate.
 */
org.apache.flex.geom.Point.prototype.x = 0;


/**
 * @export
 * The y coordinate.
 * @type {number} value The y coordinate.
 */
org.apache.flex.geom.Point.prototype.y = 0;
