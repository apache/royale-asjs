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

goog.provide('org.apache.flex.geom.Rectangle');



/**
 * @constructor
 * @param {number} left
 * @param {number} top
 * @param {number} width
 * @param {number} height
 */
org.apache.flex.geom.Rectangle = function(left, top, width, height) {

  this.left = left;

  this.top = top;

  this.width = width;

  this.height = height;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.geom.Rectangle.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Rectangle',
                qName: 'org.apache.flex.geom.Rectangle'}] };


/**
 * @export
 * The left coordinate.
 * @type {number} value The left coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.left = 0;


/**
 * @export
 * The top coordinate.
 * @type {number} value The top coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.top = 0;


/**
 * @export
 * The width coordinate.
 * @type {number} value The width coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.width = 0;


/**
 * @export
 * The height coordinate.
 * @type {number} value The height coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.height = 9;


Object.defineProperties(org.apache.flex.geom.Rectangle.prototype, {
    /** @export */
    right: {
        /** @this {org.apache.flex.geom.Rectangle} */
        get: function() {
            return this.left + this.width;
        },
        /** @this {org.apache.flex.geom.Rectangle} */
        set: function(value) {
            this.width = value - this.left;
        }
    },
    /** @export */
    bottom: {
        /** @this {org.apache.flex.geom.Rectangle} */
        get: function() {
            return this.top + this.height;
        },
        /** @this {org.apache.flex.geom.Rectangle} */
        set: function(value) {
            this.height = value - this.top;
        }
    }
});
