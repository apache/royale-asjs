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
  org.apache.flex.core.FilledRectangle.base(this, 'constructor');

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
  org.apache.flex.core.FilledRectangle.base(this, 'addedToParent');
  this.drawRect(this.x, this.y, this.width, this.height);
};


Object.defineProperties(org.apache.flex.core.FilledRectangle.prototype, {
    /** @export */
    fillColor: {
        /** @this {org.apache.flex.core.FilledRectangle} */
        get: function() {
             return this.fillColor_;
        },
        /** @this {org.apache.flex.core.FilledRectangle} */
        set: function(value) {
             this.fillColor_ = value;
        }
    }
});


/**
 * @export
 * @param {number} x The left coordinate.
 * @param {number} y The top coordinate.
 * @param {number} width The width.
 * @param {number} height The height.
 */
org.apache.flex.core.UIBase.prototype.drawRect = function(x, y, width, height) {
  this.element.style.position = 'absolute';
  this.element.style.backgroundColor = '#' + this.fillColor_.toString(16);
  if (!isNaN(x)) this.x = x;
  if (!isNaN(y)) this.y = y;
  if (!isNaN(width)) this.width = width;
  if (!isNaN(height)) this.height = height;
};
