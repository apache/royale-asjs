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
 * org.apache.flex.charts.core.IChartDataGroup
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.charts.core.IChartDataGroup');

goog.require('org.apache.flex.core.IFactory');
goog.require('org.apache.flex.core.IItemRendererParent');



/**
 * @interface
 * @extends {org.apache.flex.core.IItemRendererParent}
 */
org.apache.flex.charts.core.IChartDataGroup = function() {
};


/**
 * @param {Object} series The series containing the itemRenderer.
 * @param {number} index The position of the itemRenderer within the series.
 * @return {Object} The itemRenderer matching the series and index.
 */
org.apache.flex.charts.core.IChartDataGroup.prototype.getItemRendererForSeriesAtIndex =
  function(series, index) {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.core.IChartDataGroup.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'IChartDataGroup', qName: 'org.apache.flex.charts.core.IChartDataGroup'}],
    interfaces: [org.apache.flex.core.IItemRendererParent]
  };
