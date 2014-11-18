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

goog.provide('org.apache.flex.charts.supportClasses.ChartAxisGroup');

goog.require('org.apache.flex.charts.core.IAxisGroup');
goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 * @implements {org.apache.flex.charts.core.IAxisGroup}
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup =
    function() {
  org.apache.flex.charts.supportClasses.ChartAxisGroup.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.charts.supportClasses.ChartAxisGroup,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ChartAxisGroup',
                qName: 'org.apache.flex.charts.supportClasses.ChartAxisGroup' }],
      interfaces: [org.apache.flex.charts.core.IAxisGroup] };


/**
 * @override
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.
    prototype.createElement = function() {
  this.element = document.createElement('div');
  this.element.flexjs_wrapper = this;
  this.set_className('ChartAxisGroup');

  this.positioner = this.element;

  return this.element;
};


/**
 * @return {void}
 */
org.apache.flex.charts.supportClasses.ChartAxisGroup.prototype.removeAllElements =
function() {
  var svg = this.element;
  while (svg.lastChild) {
    svg.removeChild(svg.lastChild);
  }
};
