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

goog.provide('org.apache.flex.core.graphics.Rect');

goog.require('org.apache.flex.core.graphics.GraphicShape');



/**
 * @constructor
 * @extends {org.apache.flex.core.graphics.GraphicShape}
 */
org.apache.flex.core.graphics.Rect = function() {
  org.apache.flex.core.graphics.Rect.base(this, 'constructor');

};
goog.inherits(org.apache.flex.core.graphics.Rect,
    org.apache.flex.core.graphics.GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.Rect.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Rect',
                qName: 'org.apache.flex.core.graphics.Rect' }] };


/**
 * @expose
 * @param {number} x The x position of the top-left corner of the rectangle.
 * @param {number} y The y position of the top-left corner.
 * @param {number} width The width of the rectangle.
 * @param {number} height The height of the rectangle.
 */
org.apache.flex.core.graphics.Rect.prototype.drawRect = function(x, y, width, height) {
    var style = this.getStyleStr();
    var rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    rect.setAttribute('style', style);
    if (this.get_stroke())
    {
      rect.setAttribute('x', String(this.get_stroke().get_weight() / 2) + 'px');
      rect.setAttribute('y', String(this.get_stroke().get_weight() / 2) + 'px');
      this.setPosition(x, y, this.get_stroke().get_weight(), this.get_stroke().get_weight());
    }
    else
    {
      rect.setAttribute('x', '0' + 'px');
      rect.setAttribute('y', '0' + 'px');
      this.setPosition(x, y, 0, 0);
    }
    rect.setAttribute('width', String(width) + 'px');
    rect.setAttribute('height', String(height) + 'px');
    this.element.appendChild(rect);
  };

/**
 * @override
*/
  org.apache.flex.core.graphics.Rect.prototype.draw = function() {
    this.drawRect(this.get_x(), this.get_y(), this.get_width(), this.get_height());
  };