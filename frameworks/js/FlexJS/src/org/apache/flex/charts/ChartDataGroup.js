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

goog.provide('org.apache.flex.charts.ChartDataGroup');

goog.require('org.apache.flex.html.supportClasses.NonVirtualDataGroup');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.NonVirtualDataGroup}
 */
org.apache.flex.charts.ChartDataGroup =
    function() {
  org.apache.flex.charts.ChartDataGroup.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.charts.ChartDataGroup,
    org.apache.flex.html.supportClasses.NonVirtualDataGroup);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.ChartDataGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChartDataGroup',
                qName: 'org.apache.flex.charts.ChartDataGroup' }] };


/**
 * @override
 */
org.apache.flex.charts.ChartDataGroup.
    prototype.createElement = function() {
  this.element = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  this.element.setAttributeNS('http://www.w3.org/2000/xmlns/', 'xmlns:xlink', 'http://www.w3.org/1999/xlink');
  this.element.flexjs_wrapper = this;
  this.set_className('ChartDataGroup');

  this.positioner = this.element;

  return this.element;
};
