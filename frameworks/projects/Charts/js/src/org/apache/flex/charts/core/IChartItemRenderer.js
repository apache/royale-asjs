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
 * org_apache_flex_charts_core_IChartItemRenderer
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_charts_core_IChartItemRenderer');

goog.require('org_apache_flex_core_IItemRenderer');



/**
 * @interface
 * @extends {org_apache_flex_core_IItemRenderer}
 */
org_apache_flex_charts_core_IChartItemRenderer = function() {
};


Object.defineProperties(org_apache_flex_charts_core_IChartItemRenderer.prototype, {
    /** @export */
    xField: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    yField: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    fillColor: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    x: {
        set: function(value) {}
    },
    /** @export */
    y: {
        set: function(value) {}
    },
    /** @export */
    width: {
        set: function(value) {}
    },
    /** @export */
    height: {
        set: function(value) {}
    }
});


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_charts_core_IChartItemRenderer.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'IChartItemRenderer', qName: 'org_apache_flex_charts_core_IChartItemRenderer'}],
    interfaces: [org_apache_flex_core_IItemRenderer]
  };
