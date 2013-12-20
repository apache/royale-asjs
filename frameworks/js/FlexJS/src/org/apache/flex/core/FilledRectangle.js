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

goog.provide('org.apache.flex.core.FilledRectangle');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.FilledRectangle = function() {
  goog.base(this);

  /**
   * @private
   * @type {number}
   */
  this.fillColor_ = 0;
};
goog.inherits(org.apache.flex.core.FilledRectangle,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.FilledRectangle.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'FilledRectangle',
                qName: 'org.apache.flex.core.FilledRectangle' }] };


/**
 * @override
 */
org.apache.flex.core.FilledRectangle.prototype.addedToParent = function() {
  goog.base(this, 'addedToParent');
  this.drawRect(this.get_x(), this.get_y(), this.get_width(), this.get_height());
};


/**
 * @expose
 * @return {number} The fill color.
 */
org.apache.flex.core.UIBase.prototype.get_fillColor = function() {
  return this.fillColor_;
};


/**
 * @param {number} value The fill color.
 */
org.apache.flex.core.UIBase.prototype.set_fillColor = function(value) {
  this.fillColor_ = value;
};


/**
 * @expose
 * @param {number} x The left coordinate.
 * @param {number} y The top coordinate.
 * @param {number} width The width.
 * @param {number} height The height.
 */
org.apache.flex.core.UIBase.prototype.drawRect = function(x, y, width, height) {
  this.element.style.position = 'absolute';
  this.element.style.backgroundColor = '#' + this.fillColor_.toString(16);
  if (!isNaN(x)) this.set_x(x);
  if (!isNaN(y)) this.set_y(y);
  if (!isNaN(width)) this.set_width(width);
  if (!isNaN(height)) this.set_height(height);
};
