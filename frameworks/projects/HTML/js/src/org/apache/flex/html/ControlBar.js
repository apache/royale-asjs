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

goog.provide('org.apache.flex.html.ControlBar');

goog.require('org.apache.flex.html.Container');



/**
 * @constructor
 * @extends {org.apache.flex.html.Container}
 */
org.apache.flex.html.ControlBar = function() {
  org.apache.flex.html.ControlBar.base(this, 'constructor');

};
goog.inherits(org.apache.flex.html.ControlBar,
    org.apache.flex.html.Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.ControlBar.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ControlBar',
                qName: 'org.apache.flex.html.ControlBar'}] };


/**
 * @override
 */
org.apache.flex.html.ControlBar.prototype.createElement =
    function() {

  this.element = document.createElement('div');
  this.element.className = 'ControlBar';
  this.element.style.display = 'inline';
  this.typeNames = 'ControlBar';

  this.positioner = this.element;
  this.positioner.style.position = 'relative';
  this.element.flexjs_wrapper = this;

  return this.element;
};
