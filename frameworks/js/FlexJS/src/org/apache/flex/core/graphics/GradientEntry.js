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
 * org.apache.flex.core.graphics.GradientEntry
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.graphics.GradientEntry');


/**
 * @constructor
 * @param {number} alpha
 * @param {number} color
 * @param {number} ratio
 */
org.apache.flex.core.graphics.GradientEntry = function(alpha, color, ratio) {
  this._alpha = alpha;
  this._color = color;
  this._ratio = ratio;
};


/**
 * @private
 * @type {number}
 */
org.apache.flex.core.graphics.GradientEntry.prototype._alpha = 1.0;


/**
 * @private
 * @type {number}
 */
org.apache.flex.core.graphics.GradientEntry.prototype._color = 0x000000;


/**
 * @private
 * @type {number}
 */
org.apache.flex.core.graphics.GradientEntry.prototype._ratio = 0x000000;


/**
 * @expose
 * @return {number}
 */
org.apache.flex.core.graphics.GradientEntry.prototype.get_alpha = function() {
  return this._alpha;
};


/**
 * @expose
 * @param {number} value
 */
org.apache.flex.core.graphics.GradientEntry.prototype.set_alpha = function(value) {
  var /** @type {number} */ oldValue = this._alpha;
  if (value != oldValue) {
    this._alpha = value;
  }
};


/**
 * @expose
 * @return {number}
 */
org.apache.flex.core.graphics.GradientEntry.prototype.get_color = function() {
  return this._color;
};


/**
 * @expose
 * @param {number} value
 */
org.apache.flex.core.graphics.GradientEntry.prototype.set_color = function(value) {
  var /** @type {number} */ oldValue = this._color;
  if (value != oldValue) {
    this._color = value;
  }
};


/**
 * @expose
 * @return {number}
 */
org.apache.flex.core.graphics.GradientEntry.prototype.get_ratio = function() {
  return this._ratio;
};


/**
 * @expose
 * @param {number} value
 */
org.apache.flex.core.graphics.GradientEntry.prototype.set_ratio = function(value) {
  this._ratio = value;
};


/**
 * @expose
 * @param {org.apache.flex.core.graphics.GraphicShape} s
 */
org.apache.flex.core.graphics.GradientEntry.prototype.begin = function(s) {
  s.get_graphics().beginFill(this.get_color(), this.get_alpha());
};


/**
 * @expose
 * @param {org.apache.flex.core.graphics.GraphicShape} s
 */
org.apache.flex.core.graphics.GradientEntry.prototype.end = function(s) {
  s.get_graphics().endFill();
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.GradientEntry.prototype.FLEXJS_CLASS_INFO = { names: [{ name: 'GradientEntry', qName: 'org.apache.flex.core.graphics.GradientEntry'}] };
