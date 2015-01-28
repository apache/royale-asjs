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

/**
 * org_apache_flex_core_graphics_GradientBase
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_graphics_GradientBase');



/**
 * @constructor
 */
org_apache_flex_core_graphics_GradientBase = function() {
};


/**
 * @protected
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype.colors = [];


/**
 * @protected
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype.ratios = [];


/**
 * @protected
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype.alphas = [];


/**
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype._entries = [];


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype._rotation = 0.0;


/**
 * @expose
 * @return {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype.get_entries = function() {
  return this._entries;
};


/**
 * @expose
 * @param {Array} value
 */
org_apache_flex_core_graphics_GradientBase.prototype.set_entries = function(value) {
  this._entries = value;
};


/**
 * @expose
 *  By default, the LinearGradientStroke defines a transition
 *  from left to right across the control.
 *  Use the <code>rotation</code> property to control the transition direction.
 *  For example, a value of 180.0 causes the transition
 *  to occur from right to left, rather than from left to right.
 * @return {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype.get_rotation = function() {
  return this._rotation;
};


/**
 * @expose
 * @param {number} value
 */
org_apache_flex_core_graphics_GradientBase.prototype.set_rotation = function(value) {
  this._rotation = value;
};


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype._x = 0;


/**
 * @expose
 * @return {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype.get_x = function() {
  return this._x;
};


/**
 * @expose
 * @param {number} value
 */
org_apache_flex_core_graphics_GradientBase.prototype.set_x = function(value) {
  this._x = value;
};


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype._y = 0;


/**
 * @expose
 * @param {number} value
 */
org_apache_flex_core_graphics_GradientBase.prototype.set_y = function(value) {
  this._y = value;
};


/**
 * @expose
 * @return {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype.get_y = function() {
  return this._y;
};


/**
 * @expose
 * @return {string} A new gradient id value.
 */
org_apache_flex_core_graphics_GradientBase.prototype.get_newId = function() {
  return 'gradient' + String(Math.floor((Math.random() * 100000) + 1));
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_GradientBase.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'GradientBase', qName: 'org_apache_flex_core_graphics_GradientBase'}]
  };
