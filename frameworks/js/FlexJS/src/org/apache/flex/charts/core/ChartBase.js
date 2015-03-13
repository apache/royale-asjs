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
 * org_apache_flex_charts_core_IChart
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_charts_core_ChartBase');

goog.require('org_apache_flex_charts_core_IChart');
goog.require('org_apache_flex_events_Event');
goog.require('org_apache_flex_html_List');



/**
 * @constructor
 * @extends {org_apache_flex_html_List}
 * @implements {org_apache_flex_charts_core_IChart}
 */
org_apache_flex_charts_core_ChartBase =
    function() {
  org_apache_flex_charts_core_ChartBase.base(this, 'constructor');
  this.className = 'ChartBase';
};
goog.inherits(
    org_apache_flex_charts_core_ChartBase,
    org_apache_flex_html_List);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_charts_core_ChartBase.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'ChartBase', qName: 'org_apache_flex_charts_core_ChartBase'}]
  };


/**
 * @override
 */
org_apache_flex_charts_core_ChartBase.prototype.createElement = function() {
    org_apache_flex_charts_core_ChartBase.base(this, 'createElement');
    this.element.style.border = 'none';
    this.element.style.overflow = 'visible';
    return this.element;
  };


/**
 * @private
 * @type {Array}
 */
org_apache_flex_charts_core_ChartBase.prototype.series_ = null;


Object.defineProperties(org_apache_flex_charts_core_ChartBase.prototype, {
    'series': {
		get: function() {
             return this.series_;
        },
        set: function(value) {
             this.series_ = value;
             this.dispatchEvent(new org_apache_flex_events_Event('seriesChanged'));
        }
	}
});
