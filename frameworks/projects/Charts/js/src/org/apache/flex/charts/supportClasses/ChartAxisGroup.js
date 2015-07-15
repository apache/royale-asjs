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

goog.provide('org.apache.flex.charts.supportClasses.ChartAxisGroup');

goog.require('org.apache.flex.charts.core.IAxisGroup');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.core.graphics.Path');
goog.require('org.apache.flex.html.Label');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 * @implements {org.apache.flex.charts.core.IAxisGroup}
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup =
    function() {
  org.apache.flex.charts.supportClasses.ChartAxisGroup.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.charts.supportClasses.ChartAxisGroup,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChartAxisGroup',
                qName: 'org.apache.flex.charts.supportClasses.ChartAxisGroup' }],
      interfaces: [org.apache.flex.charts.core.IAxisGroup] };


/**
 * @override
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.
    prototype.createElement = function() {
  this.element = document.createElement('div');
  this.element.flexjs_wrapper = this;
  this.className = 'ChartAxisGroup';

  this.positioner = this.element;

  return this.element;
};


/**
 * @export
 * @param {string} text The label to display.
 * @param {number} xpos The x position of the label.
 * @param {number} ypos The y position of the label.
 * @param {number} boxWidth The size of the area for the label.
 * @param {number} boxHeight The size of the area for the label.
 * @param {org.apache.flex.core.graphics.IStroke} tickFill The color of the path.
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.drawHorizontalTickLabel =
function(text, xpos, ypos, boxWidth, boxHeight, tickFill) {
  var label = new org.apache.flex.html.Label();
  this.addElement(label);
  label.text = text;
  label.x = xpos - label.width / 2;
  label.y = ypos;
};


/**
 * @export
 * @param {string} text The label to display.
 * @param {number} xpos The x position of the label.
 * @param {number} ypos The y position of the label.
 * @param {number} boxWidth The size of the area for the label.
 * @param {number} boxHeight The size of the area for the label.
 * @param {org.apache.flex.core.graphics.IStroke} tickFill The color of the path.
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.drawVerticalTickLabel =
function(text, xpos, ypos, boxWidth, boxHeight, tickFill) {
  var label = new org.apache.flex.html.Label();
  this.addElement(label);
  label.text = text;
  label.x = xpos;
  label.y = ypos - label.height / 2;
};


/**
 * @export
 * @param {number} originX The x position of the path.
 * @param {number} originY The y position of the path.
 * @param {number} width The size of the area for the path.
 * @param {number} height The size of the area for the path.
 * @param {string} marks The path to draw.
 * @param {org.apache.flex.core.graphics.IStroke} tickStroke The color of the path.
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.drawTickMarks =
function(originX, originY, width, height, marks, tickStroke) {
  var tickPath = new org.apache.flex.core.graphics.Path();
  tickPath.x = 0;
  tickPath.y = 0;
  tickPath.width = this.width;
  tickPath.height = this.height;
  this.addElement(tickPath);
  tickPath.stroke = tickStroke;
  tickPath.drawPath(0, 0, marks);
};


/**
 * @export
 * @param {number} originX The x position of the path.
 * @param {number} originY The y position of the path.
 * @param {number} width The size of the area for the path.
 * @param {number} height The size of the area for the path.
 * @param {org.apache.flex.core.graphics.IStroke} lineStroke The color of the path.
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.drawAxisLine =
function(originX, originY, width, height, lineStroke) {
  var axisPath = new org.apache.flex.core.graphics.Path();
  axisPath.x = 0;
  axisPath.y = 0;
  axisPath.width = this.width;
  axisPath.height = this.height;
  this.addElement(axisPath);
  axisPath.stroke = lineStroke;
  var pathLine = 'M ' + String(originX) + ' ' + String(originY) + ' l ' + String(width) + ' ' + String(height);
  axisPath.drawPath(0, 0, pathLine);
};


/**
 * @return {void}
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.removeAllElements =
function() {
  var svg = this.element;
  while (svg.lastChild) {
    svg.removeChild(svg.lastChild);
  }
};
