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
 * org.apache.flex.charts.core.IChart
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.charts.core.ChartBase');

goog.require('org.apache.flex.charts.core.IChart');
goog.require('org.apache.flex.events.Event');
goog.require('org.apache.flex.html.List');



/**
 * @constructor
 * @extends {org.apache.flex.html.List}
 * @implements {org.apache.flex.charts.core.IChart}
 */
org.apache.flex.charts.core.ChartBase =
    function() {
  org.apache.flex.charts.core.ChartBase.base(this, 'constructor');
  this.className = 'ChartBase';
};
goog.inherits(
    org.apache.flex.charts.core.ChartBase,
    org.apache.flex.html.List);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.core.ChartBase.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'ChartBase', qName: 'org.apache.flex.charts.core.ChartBase'}]
  };


/**
 * @override
 */
org.apache.flex.charts.core.ChartBase.prototype.createElement = function() {
    org.apache.flex.charts.core.ChartBase.base(this, 'createElement');
    this.element.style.border = 'none';
    this.element.style.overflow = 'visible';
    return this.element;
  };


/**
 * @private
 * @type {Array}
 */
org.apache.flex.charts.core.ChartBase.prototype.series_ = null;


Object.defineProperties(org.apache.flex.charts.core.ChartBase.prototype, {
    /** @export */
    series: {
        /** @this {org.apache.flex.charts.core.ChartBase} */
        get: function() {
             return this.series_;
        },
        /** @this {org.apache.flex.charts.core.ChartBase} */
        set: function(value) {
             this.series_ = value;
             this.dispatchEvent(new org.apache.flex.events.Event('seriesChanged'));
        }
    }
});
