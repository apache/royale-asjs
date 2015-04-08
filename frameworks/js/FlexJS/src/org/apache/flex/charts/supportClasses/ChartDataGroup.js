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

goog.provide('org_apache_flex_charts_supportClasses_ChartDataGroup');

goog.require('org_apache_flex_charts_core_IChartDataGroup');
goog.require('org_apache_flex_html_supportClasses_NonVirtualDataGroup');



/**
 * @constructor
 * @extends {org_apache_flex_html_supportClasses_NonVirtualDataGroup}
 * @implements {org_apache_flex_charts_core_IChartDataGroup}
 */
org_apache_flex_charts_supportClasses_ChartDataGroup =
    function() {
  org_apache_flex_charts_supportClasses_ChartDataGroup.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_charts_supportClasses_ChartDataGroup,
    org_apache_flex_html_supportClasses_NonVirtualDataGroup);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_charts_supportClasses_ChartDataGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChartDataGroup',
                qName: 'org_apache_flex_charts_supportClasses_ChartDataGroup' }],
      interfaces: [org_apache_flex_charts_core_IChartDataGroup] };


/**
 * @override
 */
org_apache_flex_charts_supportClasses_ChartDataGroup.
    prototype.createElement = function() {
  this.element = document.createElement('div');
  this.element.flexjs_wrapper = this;
  this.className = 'ChartDataGroup';

  this.positioner = this.element;

  return this.element;
};


/**
 * @expose
 * @param {Object} series The series containing the itemRenderer.
 * @param {number} index The position of the itemRenderer within the series.
 * @return {Object} The itemRenderer that matches the series and index.
 */
org_apache_flex_charts_supportClasses_ChartDataGroup.prototype.getItemRendererForSeriesAtIndex =
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

