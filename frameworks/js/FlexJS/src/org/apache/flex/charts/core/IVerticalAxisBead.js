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
 * org.apache.flex.charts.core.IVerticalAxisBead
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.charts.core.IVerticalAxisBead');

goog.require('org.apache.flex.charts.core.IAxisBead');



/**
 * @interface
 * @extends {org.apache.flex.charts.core.IAxisBead}
 */
org.apache.flex.charts.core.IVerticalAxisBead = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.core.IVerticalAxisBead.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'IVerticalAxisBead', qName: 'org.apache.flex.charts.core.IVerticalAxisBead'}],
    interfaces: [org.apache.flex.charts.core.IAxisBead]
  };


/**
 * @param {number} value
 */
org.apache.flex.charts.core.IVerticalAxisBead.prototype.set_axisWidth = function(value) {};


/**
 * @return {number}
 */
org.apache.flex.charts.core.IVerticalAxisBead.prototype.get_axisWidth = function() {};


/**
 * @return {number}
 */
org.apache.flex.charts.core.IVerticalAxisBead.prototype.get_maximum = function() {};


/**
 * @return {number}
 */
org.apache.flex.charts.core.IVerticalAxisBead.prototype.get_minimum = function() {};
