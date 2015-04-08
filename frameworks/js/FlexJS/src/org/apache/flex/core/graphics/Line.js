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

goog.provide('org_apache_flex_core_graphics_Line');

goog.require('org_apache_flex_core_graphics_GraphicShape');



/**
 * @constructor
 * @extends {org_apache_flex_core_graphics_GraphicShape}
 */
org_apache_flex_core_graphics_Line = function() {
  org_apache_flex_core_graphics_Line.base(this, 'constructor');

};
goog.inherits(org_apache_flex_core_graphics_Line,
    org_apache_flex_core_graphics_GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_Line.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Line',
                qName: 'org_apache_flex_core_graphics_Line' }] };


/**
 * @expose
 *  @param {number} x1 The x1 attribute defines the start of the line on the x-axis.
 *  @param {number} y1 The y1 attribute defines the start of the line on the y-axis.
 *  @param {number} x2 The x2 attribute defines the end of the line on the x-axis.
 *  @param {number} y2 The y2 attribute defines the end of the line on the y-axis.
 */
org_apache_flex_core_graphics_Line.prototype.drawLine = function(x1, y1, x2, y2) {
    var style = this.getStyleStr();
    var line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    line.flexjs_wrapper = this;
    line.setAttribute('style', style);
    line.setAttribute('x1', 0);
    line.setAttribute('y1', y1);
    line.setAttribute('x2', x2 - x1);
    line.setAttribute('y2', y2);
    this.setPosition(x1, y2, this.stroke.weight, this.stroke.weight);
    this.element.appendChild(line);

    this.resize(x, y, line.getBBox());
  };


/**
 * @override
 * @expose
 * @param {number} x X position.
 * @param {number} y Y position.
 * @param {Object} bbox The bounding box of the svg element.
 */
org_apache_flex_core_graphics_Line.prototype.resize = function(x, y, bbox) {
  this.element.setAttribute('width', String(bbox.width) + 'px');
  this.element.setAttribute('height', String(bbox.height) + 'px');

  this.element.setAttribute('style', 'position:absolute; left:' + String(x + bbox.x - this.xOffset_) +
      'px; top:' + String(bbox.y - this.yOffset_) + 'px;');
};
