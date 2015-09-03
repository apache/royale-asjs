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

goog.provide('org.apache.flex.geom.Size');



/**
 * @constructor
 * @param {number} width
 * @param {number} height
 */
org.apache.flex.geom.Size = function(width, height) {

  this.width = width;

  this.height = height;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.geom.Size.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Size',
                qName: 'org.apache.flex.geom.Size'}] };


/**
 * @export
 * The width value.
 * @type {number} value The width value.
 */
org.apache.flex.geom.Size.prototype.width = 0;


/**
 * @export
 * The height value.
 * @type {number} value The height value.
 */
org.apache.flex.geom.Size.prototype.height = 0;
