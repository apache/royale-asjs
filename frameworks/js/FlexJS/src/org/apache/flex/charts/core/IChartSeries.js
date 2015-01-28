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
 * org_apache_flex_charts_core_IChartSeries
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_charts_core_IChartSeries');

goog.require('mx_core_IFactory');



/**
 * @interface
 */
org_apache_flex_charts_core_IChartSeries = function() {
};


/**
 * @return {string}
 */
org_apache_flex_charts_core_IChartSeries.prototype.get_xField = function() {};


/**
 * @param {string} value
 */
org_apache_flex_charts_core_IChartSeries.prototype.set_xField = function(value) {};


/**
 * @return {string}
 */
org_apache_flex_charts_core_IChartSeries.prototype.get_yField = function() {};


/**
 * @param {string} value
 */
org_apache_flex_charts_core_IChartSeries.prototype.set_yField = function(value) {};


/**
 * @return {number}
 */
org_apache_flex_charts_core_IChartSeries.prototype.get_fillColor = function() {};


/**
 * @param {number} value
 */
org_apache_flex_charts_core_IChartSeries.prototype.set_fillColor = function(value) {};


/**
 * @return {mx_core_IFactory}
 */
org_apache_flex_charts_core_IChartSeries.prototype.get_itemRenderer = function() {};


/**
 * @param {mx_core_IFactory} value
 */
org_apache_flex_charts_core_IChartSeries.prototype.set_itemRenderer = function(value) {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_charts_core_IChartSeries.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'IChartSeries', qName: 'org_apache_flex_charts_core_IChartSeries'}]
  };
