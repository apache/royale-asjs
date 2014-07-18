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
 * org.apache.flex.charts.core.IChartItemRenderer
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.charts.core.IChartItemRenderer');

goog.require('org.apache.flex.core.IItemRenderer');



/**
 * @interface
 * @extends {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.charts.core.IChartItemRenderer = function() {
};


/**
 * @return {string}
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.get_xField = function() {};


/**
 * @param {string} value
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.set_xField = function(value) {};


/**
 * @return {string}
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.get_yField = function() {};


/**
 * @param {string} value
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.set_yField = function(value) {};


/**
 * @return {number}
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.get_fillColor = function() {};


/**
 * @param {number} value
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.set_fillColor = function(value) {};


/**
 * @param {number} value
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.set_x = function(value) {};


/**
 * @param {number} value
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.set_y = function(value) {};


/**
 * @param {number} value
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.set_width = function(value) {};


/**
 * @param {number} value
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.set_height = function(value) {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.core.IChartItemRenderer.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'IChartItemRenderer', qName: 'org.apache.flex.charts.core.IChartItemRenderer'}],
    interfaces: [org.apache.flex.core.IItemRenderer]
  };
