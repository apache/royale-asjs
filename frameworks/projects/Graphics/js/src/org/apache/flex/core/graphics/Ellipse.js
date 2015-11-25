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

goog.provide('org.apache.flex.core.graphics.Ellipse');

goog.require('org.apache.flex.core.graphics.GraphicShape');



/**
 * @constructor
 * @extends {org.apache.flex.core.graphics.GraphicShape}
 */
org.apache.flex.core.graphics.Ellipse = function() {
  org.apache.flex.core.graphics.Ellipse.base(this, 'constructor');

};
goog.inherits(org.apache.flex.core.graphics.Ellipse,
    org.apache.flex.core.graphics.GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.Ellipse.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Ellipse',
                qName: 'org.apache.flex.core.graphics.Ellipse' }] };


/**
 * @export
 * @param {number} x The x position of the top-left corner of the bounding box of the ellipse.
 * @param {number} y The y position of the top-left corner of the bounding box of the ellipse.
 * @param {number} width The width of the ellipse.
 * @param {number} height The height of the ellipse.
 */
org.apache.flex.core.graphics.Ellipse.prototype.drawEllipse = function(x, y, width, height) {
    var style = this.getStyleStr();
    var ellipse = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse');
    ellipse.flexjs_wrapper = this;
    ellipse.setAttribute('style', style);
    if (this.stroke)
    {
      ellipse.setAttribute('cx', String(width / 2 + this.stroke.weight));
      ellipse.setAttribute('cy', String(height / 2 + this.stroke.weight));
      this.setPosition(x, y, this.stroke.weight * 2, this.stroke.weight * 2);
    }
    else
    {
      ellipse.setAttribute('cx', String(width / 2));
      ellipse.setAttribute('cy', String(height / 2));
      this.setPosition(x, y, 0, 0);
    }
    ellipse.setAttribute('rx', String(width / 2));
    ellipse.setAttribute('ry', String(height / 2));
    this.element.appendChild(ellipse);

    this.resize(x, y, ellipse.getBBox());
  };


/**
 * @override
*/
org.apache.flex.core.graphics.Ellipse.prototype.draw = function() {
    this.drawEllipse(this.x, this.y, this.width, this.height);
  };
