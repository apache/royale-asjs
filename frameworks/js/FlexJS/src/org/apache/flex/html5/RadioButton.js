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

goog.provide('org.apache.flex.html5.RadioButton');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html5.RadioButton = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html5.RadioButton,
    org.apache.flex.core.UIBase);


/**
 * @override
 */
org.apache.flex.html5.RadioButton.prototype.createElement =
    function() {
  var rb;

  this.element = document.createElement('label');

  rb = document.createElement('input');
  rb.type = 'radio';
  this.element.appendChild(rb);
  this.element.appendChild(document.createTextNode('radio button'));

  this.positioner = this.element;

  return this.element;
};


/**
 * @expose
 * @return {string} The groupName getter.
 */
org.apache.flex.html5.RadioButton.prototype.get_groupName =
    function() {
  return this.element.childNodes.item(0).name;
};


/**
 * @expose
 * @param {string} value The groupName setter.
 */
org.apache.flex.html5.RadioButton.prototype.set_groupName =
    function(value) {
  this.element.childNodes.item(0).name = value;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org.apache.flex.html5.RadioButton.prototype.get_text =
    function() {
  return this.element.childNodes.item(1).nodeValue;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org.apache.flex.html5.RadioButton.prototype.set_text =
    function(value) {
  this.element.childNodes.item(1).nodeValue = value;
};


/**
 * @expose
 * @return {boolean} The selected getter.
 */
org.apache.flex.html5.RadioButton.prototype.get_selected =
    function() {
  return this.element.childNodes.item(0).checked;
};


/**
 * @expose
 * @param {boolean} value The selected setter.
 */
org.apache.flex.html5.RadioButton.prototype.set_selected =
    function(value) {
  this.element.childNodes.item(0).checked = value;
};
