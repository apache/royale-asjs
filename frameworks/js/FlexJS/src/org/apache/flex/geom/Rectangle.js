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
 */
org.apache.flex.geom.Rectangle = function(left, top, width, height) {

  /**
   * @protected
   * @type {number}
   */
  this.left = left;

  /**
   * @protected
   * @type {number}
   */
  this.top = top;

  /**
   * @protected
   * @type {number}
   */
  this.width = width;

  /**
   * @protected
   * @type {number}
   */
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
 * @expose
 * The left coordinate.
 * @return {number} value The left coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.get_left = 
	function() {
  return this.left;
};


/**
 * @expose
 * The left coordinate.
 * @param {number} value The left coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.set_left = 
	function(value) {
  this.left = value;
};


/**
 * @expose
 * The top coordinate.
 * @return {number} value The top coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.get_top = 
	function() {
  return this.top;
};


/**
 * @expose
 * The top coordinate.
 * @param {number} value The top coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.set_top = 
	function(value) {
  this.top = value;
};


/**
 * @expose
 * The width coordinate.
 * @return {number} value The width coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.get_width = 
	function() {
  return this.width;
};


/**
 * @expose
 * The width coordinate.
 * @param {number} value The width coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.set_width = 
	function(value) {
  this.width = value;
};


/**
 * @expose
 * The height coordinate.
 * @return {number} value The height coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.get_height = 
	function() {
  return this.height;
};


/**
 * @expose
 * The height coordinate.
 * @param {number} value The height coordinate.
 */
org.apache.flex.geom.Rectangle.prototype.set_height = 
	function(value) {
  this.height = value;
};


