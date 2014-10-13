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
 * org.apache.flex.charts.core.IAxisBead
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.charts.core.IAxisBead');

goog.require('org.apache.flex.core.IBead');



/**
 * @interface
 * @extends {org.apache.flex.core.IBead}
 */
org.apache.flex.charts.core.IAxisBead = function() {
};


/**
 * @return {string}
 */
org.apache.flex.charts.core.IAxisBead.prototype.get_placement = function() {};


/**
 * @param {string} value
 */
org.apache.flex.charts.core.IAxisBead.prototype.set_placement = function(value) {};


/**
 * @return {Object}
 */
org.apache.flex.charts.core.IAxisBead.prototype.get_axisStroke = function() {};


/**
 * @param {Object} value
 */
org.apache.flex.charts.core.IAxisBead.prototype.set_axisStroke = function(value) {};


/**
 * @return {Object}
 */
org.apache.flex.charts.core.IAxisBead.prototype.get_tickStroke = function() {};


/**
 * @param {Object} value
 */
org.apache.flex.charts.core.IAxisBead.prototype.set_tickStroke = function(value) {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.core.IAxisBead.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'IAxisBead', qName: 'org.apache.flex.charts.core.IAxisBead'}],
    interfaces: [org.apache.flex.core.IBead]
  };
