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

goog.provide('org_apache_flex_core_graphics_Text');

goog.require('org_apache_flex_core_graphics_GraphicShape');



/**
 * @constructor
 * @extends {org_apache_flex_core_graphics_GraphicShape}
 */
org_apache_flex_core_graphics_Text = function() {
  org_apache_flex_core_graphics_Text.base(this, 'constructor');

};
goog.inherits(org_apache_flex_core_graphics_Text,
    org_apache_flex_core_graphics_GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_Text.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Rect',
                qName: 'org_apache_flex_core_graphics_Text' }] };


/**
 * @export
 * @param {string} value The text to be drawn.
 * @param {number} x The x position of the top-left corner of the rectangle.
 * @param {number} y The y position of the top-left corner.
 */
org_apache_flex_core_graphics_Text.prototype.drawText = function(value, x, y) {
    var style = this.getStyleStr();
    var text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    text.flexjs_wrapper = this;
    text.setAttribute('style', style);
    text.setAttribute('x', String(x) + 'px');
    text.setAttribute('y', String(y) + 'px');
    this.setPosition(x, y, 0, 0);
    var textNode = document.createTextNode(value);
    text.appendChild(textNode);
    this.element.appendChild(text);

    this.resize(x, y, text.getBBox());
  };


/**
 * @override
*/
org_apache_flex_core_graphics_Text.prototype.draw = function() {

};
