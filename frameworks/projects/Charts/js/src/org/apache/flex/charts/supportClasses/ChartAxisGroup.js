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

goog.provide('org_apache_flex_charts_supportClasses_ChartAxisGroup');

goog.require('org_apache_flex_charts_core_IAxisGroup');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_core_graphics_Path');
goog.require('org_apache_flex_html_Label');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 * @implements {org_apache_flex_charts_core_IAxisGroup}
 */
org_apache_flex_charts_supportClasses_ChartAxisGroup =
    function() {
  org_apache_flex_charts_supportClasses_ChartAxisGroup.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_charts_supportClasses_ChartAxisGroup,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_charts_supportClasses_ChartAxisGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChartAxisGroup',
                qName: 'org_apache_flex_charts_supportClasses_ChartAxisGroup' }],
      interfaces: [org_apache_flex_charts_core_IAxisGroup] };


/**
 * @override
 */
org_apache_flex_charts_supportClasses_ChartAxisGroup.
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
 * @param {org_apache_flex_core_graphics_IStroke} tickFill The color of the path.
 */
org_apache_flex_charts_supportClasses_ChartAxisGroup.prototype.drawHorizontalTickLabel =
function(text, xpos, ypos, boxWidth, boxHeight, tickFill) {
  var label = new org_apache_flex_html_Label();
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
 * @param {org_apache_flex_core_graphics_IStroke} tickFill The color of the path.
 */
org_apache_flex_charts_supportClasses_ChartAxisGroup.prototype.drawVerticalTickLabel =
function(text, xpos, ypos, boxWidth, boxHeight, tickFill) {
  var label = new org_apache_flex_html_Label();
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
 * @param {org_apache_flex_core_graphics_IStroke} tickStroke The color of the path.
 */
org_apache_flex_charts_supportClasses_ChartAxisGroup.prototype.drawTickMarks =
function(originX, originY, width, height, marks, tickStroke) {
  var tickPath = new org_apache_flex_core_graphics_Path();
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
 * @param {org_apache_flex_core_graphics_IStroke} lineStroke The color of the path.
 */
org_apache_flex_charts_supportClasses_ChartAxisGroup.prototype.drawAxisLine =
function(originX, originY, width, height, lineStroke) {
  var axisPath = new org_apache_flex_core_graphics_Path();
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
org_apache_flex_charts_supportClasses_ChartAxisGroup.prototype.removeAllElements =
function() {
  var svg = this.element;
  while (svg.lastChild) {
    svg.removeChild(svg.lastChild);
  }
};
