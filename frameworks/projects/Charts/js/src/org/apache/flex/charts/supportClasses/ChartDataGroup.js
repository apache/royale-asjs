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

goog.provide('org.apache.flex.charts.supportClasses.ChartDataGroup');

goog.require('org.apache.flex.charts.core.IChartDataGroup');
goog.require('org.apache.flex.html.supportClasses.DataGroup');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.DataGroup}
 * @implements {org.apache.flex.charts.core.IChartDataGroup}
 */
org.apache.flex.charts.supportClasses.ChartDataGroup =
    function() {
  org.apache.flex.charts.supportClasses.ChartDataGroup.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.charts.supportClasses.ChartDataGroup,
    org.apache.flex.html.supportClasses.DataGroup);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.supportClasses.ChartDataGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChartDataGroup',
                qName: 'org.apache.flex.charts.supportClasses.ChartDataGroup' }],
      interfaces: [org.apache.flex.charts.core.IChartDataGroup] };


/**
 * @override
 */
org.apache.flex.charts.supportClasses.ChartDataGroup.
    prototype.createElement = function() {
  this.element = document.createElement('div');
  this.element.style.position = 'relative';
  this.element.flexjs_wrapper = this;
  this.className = 'ChartDataGroup';

  this.positioner = this.element;

  return this.element;
};


/**
 * @export
 * @param {Object} series The series containing the itemRenderer.
 * @param {number} index The position of the itemRenderer within the series.
 * @return {Object} The itemRenderer that matches the series and index.
 */
org.apache.flex.charts.supportClasses.ChartDataGroup.prototype.getItemRendererForSeriesAtIndex =
function(series, index) {
  var n = this.numElements;
  for (var i = 0; i < n; i++)
  {
    var child = this.getElementAt(i);
    if (child && child.series == series) {
      if (index === 0) return child;
      --index;
    }
  }

  return null;
};

