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

goog.provide('org.apache.flex.charts.supportClasses.WedgeItemRenderer');

goog.require('org.apache.flex.charts.core.IChartItemRenderer');
goog.require('org.apache.flex.core.FilledRectangle');
goog.require('org.apache.flex.html.supportClasses.DataItemRenderer');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.DataItemRenderer}
 * @implements {org.apache.flex.charts.core.IChartItemRenderer}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer =
    function() {
  goog.base(this);
  this.className = 'WedgeItemRenderer';
};
goog.inherits(
    org.apache.flex.charts.supportClasses.WedgeItemRenderer,
    org.apache.flex.html.supportClasses.DataItemRenderer);


/**
 * @type {Object}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype._itemRendererParent = null;


/**
 * @expose
 * @return {Object}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.get_itemRendererParent = function() {
  return this._itemRendererParent;
};


/**
 * @expose
 * @param {Object} value
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.set_itemRendererParent = function(value) {
  this._itemRendererParent = value;
};


/**
 * @type {string}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype._yField = 'y';


/**
 * @expose
 * @return {string}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.get_yField = function() {
  return this._yField;
};


/**
 * @expose
 * @param {string} value
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.set_yField = function(value) {
  this._yField = value;
};


/**
 * @type {string}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype._xField = 'x';


/**
 * @expose
 * @return {string}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.get_xField = function() {
  return this._xField;
};


/**
 * @expose
 * @param {string} value
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.set_xField = function(value) {
  this._xField = value;
};


/**
 * @type {number}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype._fillColor = 0;


/**
 * @expose
 * @return {number}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.get_fillColor = function() {
  return this._fillColor;
};


/**
 * @expose
 * @param {number} value
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.set_fillColor = function(value) {
  this._fillColor = value;
};


/**
 * @expose
 * @param {Object} value
 * @override
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.set_data = function(value) {
  goog.base(this, 'set_data', value);
  if (this.filledRect == null) {
    this.filledRect = new org.apache.flex.core.FilledRectangle();
    this.addElement(this.filledRect);
  }
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'WedgeItemRenderer',
                qName: 'org.apache.flex.charts.supportClasses.WedgeItemRenderer'}],
      interfaces: [org.apache.flex.charts.core.IChartItemRenderer] };


/**
 * @expose
 * @param {number} x The center of the pie.
 * @param {number} y The center of the pie.
 * @param {number} startAngle The starting angle of the wedge.
 * @param {number} arc The sweep of the wedge.
 * @param {number} radius The radius of the pie.
 * @param {number} yRadius The vertical radius of the pie if different from the normal radius.
 * @param {bool} continueFlag Continue drawing from that position.
 */
org.apache.flex.charts.supportClasses.WedgeItemRenderer.prototype.drawWedge =
function(x, y,
         startAngle, arc,
         radius, yRadius,
		continueFlag) {
  var chartArea = this.get_itemRendererParent();
  var color = Number(this.get_fillColor()).toString(16);
  if (color.length == 2) color = '00' + color;
  if (color.length == 4) color = '00' + color;

  var x1 = x + radius * Math.cos(startAngle);
  var y1 = y + radius * Math.sin(startAngle);
  var x2 = x + radius * Math.cos(startAngle + arc);
  var y2 = y + radius * Math.sin(startAngle + arc);

  var pathString = 'M' + x + ' ' + y + ' L' + x1 + ' ' + y1 + ' A' + radius + ' ' + radius +
                   ' 0 0 1 ' + x2 + ' ' + y2 + ' z';

  var style = 'fill:#' + String(color) + ';stroke:black;stroke-width:0';

  var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
  path.setAttribute('style', style);
  path.setAttribute('d', pathString);

  chartArea.element.appendChild(path);
};

