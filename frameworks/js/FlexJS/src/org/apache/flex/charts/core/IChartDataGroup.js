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
 *
 * org_apache_flex_charts_core_IChartDataGroup
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_charts_core_IChartDataGroup');

goog.require('mx_core_IFactory');
goog.require('org_apache_flex_core_IItemRendererParent');



/**
 * @interface
 * @extends {org_apache_flex_core_IItemRendererParent}
 */
org_apache_flex_charts_core_IChartDataGroup = function() {
};


/**
 * @param {Object} series The series containing the itemRenderer.
 * @param {number} index The position of the itemRenderer within the series.
 * @return {Object} The itemRenderer matching the series and index.
 */
org_apache_flex_charts_core_IChartDataGroup.prototype.getItemRendererForSeriesAtIndex =
  function(series, index) {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_charts_core_IChartDataGroup.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'IChartDataGroup', qName: 'org_apache_flex_charts_core_IChartDataGroup'}],
    interfaces: [org_apache_flex_core_IItemRendererParent]
  };
