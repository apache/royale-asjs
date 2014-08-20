/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.charts.supportClasses.BoxItemRenderer');

goog.require('org.apache.flex.charts.core.IChartItemRenderer');
goog.require('org.apache.flex.core.FilledRectangle');
goog.require('org.apache.flex.html.supportClasses.DataItemRenderer');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.DataItemRenderer}
 * @implements {org.apache.flex.charts.core.IChartItemRenderer}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer =
    function() {
  goog.base(this);
  this.className = 'BoxItemRenderer';
};
goog.inherits(
    org.apache.flex.charts.supportClasses.BoxItemRenderer,
    org.apache.flex.html.supportClasses.DataItemRenderer);


/**
 * @type {Object}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype._itemRendererParent = null;


/**
 * @expose
 * @return {Object}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.get_itemRendererParent = function() {
  return this._itemRendererParent;
};


/**
 * @expose
 * @param {Object} value
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.set_itemRendererParent = function(value) {
  this._itemRendererParent = value;
};


/**
 * @type {string}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype._yField = 'y';


/**
 * @expose
 * @return {string}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.get_yField = function() {
  return this._yField;
};


/**
 * @expose
 * @param {string} value
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.set_yField = function(value) {
  this._yField = value;
};


/**
 * @type {string}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype._xField = 'x';


/**
 * @expose
 * @return {string}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.get_xField = function() {
  return this._xField;
};


/**
 * @expose
 * @param {string} value
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.set_xField = function(value) {
  this._xField = value;
};


/**
 * @type {number}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype._fillColor = 0;


/**
 * @expose
 * @return {number}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.get_fillColor = function() {
  return this._fillColor;
};


/**
 * @expose
 * @param {number} value
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.set_fillColor = function(value) {
  this._fillColor = value;
};


/**
 * @expose
 * @param {Object} value
 * @override
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.set_data = function(value) {
  goog.base(this, 'set_data', value);
  if (this.filledRect == null) {
    this.filledRect = new org.apache.flex.core.FilledRectangle();
    this.addElement(this.filledRect);
  }
};


/**
 * @expose
 * @param {number} value
 * @override
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.set_width = function(value) {
  goog.base(this, 'set_width', value);
  this.drawBar(this.get_x(), this.get_y(), this.get_width(), this.get_height());
};


/**
 * @expose
 * @param {number} value
 * @override
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.set_height = function(value) {
  goog.base(this, 'set_height', value);
  this.drawBar(this.get_x(), this.get_y(), this.get_width(), this.get_height());
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BoxItemRenderer',
                qName: 'org.apache.flex.charts.supportClasses.BoxItemRenderer'}],
      interfaces: [org.apache.flex.charts.core.IChartItemRenderer] };


/**
 * @expose
 * @param {number} x The upper left corner of the box.
 * @param {number} y The upper left corner of the box.
 * @param {number} width The width of the box.
 * @param {number} height The height of the box.
 */
org.apache.flex.charts.supportClasses.BoxItemRenderer.prototype.drawBar =
function(x, y, width, height) {
  var chartArea = this.get_itemRendererParent();
  var color = Number(this.get_fillColor()).toString(16);
  if (color.length == 2) color = '00' + color;
  if (color.length == 4) color = '00' + color;

  var style = 'fill:#' + String(color) + ';stroke:black;stroke-width:0';

  var pathString = 'M' + x + ' ' + y +
                   ' l' + width + ' ' + '0' +
                   ' l' + '0 ' + String(height) +
                   ' l' + String(0 - width) + ' 0' +
                   ' l' + '0 ' + String(0 - height) + ' z';

  var path = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
  path.setAttribute('style', style);
  path.setAttribute('x', String(x));
  path.setAttribute('y', String(y));
  path.setAttribute('width', String(width));
  path.setAttribute('height', String(height));

  chartArea.element.appendChild(path);
};

