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

goog.provide('org.apache.flex.html.RadioButton');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.RadioButton = function() {
  org.apache.flex.html.RadioButton.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.RadioButton,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.RadioButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'RadioButton',
                qName: 'org.apache.flex.html.RadioButton'}] };


/**
 * Provides unique name
 */
org.apache.flex.html.RadioButton.radioCounter = 0;


/**
 * @override
 */
org.apache.flex.html.RadioButton.prototype.createElement =
    function() {

  this.input = document.createElement('input');
  this.input.type = 'radio';
  this.input.id = '_radio_' + org.apache.flex.html.RadioButton.radioCounter++;

  this.textNode = document.createTextNode('radio button');

  this.labelFor = document.createElement('label');
  this.labelFor.appendChild(this.input);
  this.labelFor.appendChild(this.textNode);

  this.element = this.labelFor;
  this.positioner = this.element;
  this.input.flexjs_wrapper = this;
  this.element.flexjs_wrapper = this;
  this.textNode.flexjs_wrapper = this;

  return this.element;
};


/**
 * @expose
 */
org.apache.flex.html.RadioButton.prototype.initModel =
    function() {
};


/**
 * @expose
 */
org.apache.flex.html.RadioButton.prototype.initSkin =
    function() {
};


/**
 * @override
 */
org.apache.flex.html.RadioButton.prototype.set_id = function(value) {
  org.apache.flex.html.RadioButton.base(this, 'set_id', value);
  this.labelFor.id = value;
  this.input.id = value;
};


/**
 * @expose
 * @return {string} The groupName getter.
 */
org.apache.flex.html.RadioButton.prototype.get_groupName =
    function() {
  return this.input.name;
};


/**
 * @expose
 * @param {string} value The groupName setter.
 */
org.apache.flex.html.RadioButton.prototype.set_groupName =
    function(value) {
  this.input.name = value;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org.apache.flex.html.RadioButton.prototype.get_text =
    function() {
  return this.textNode.nodeValue;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org.apache.flex.html.RadioButton.prototype.set_text =
    function(value) {
  this.textNode.nodeValue = value;
};


/**
 * @expose
 * @return {boolean} The selected getter.
 */
org.apache.flex.html.RadioButton.prototype.get_selected =
    function() {
  return this.input.checked;
};


/**
 * @expose
 * @param {boolean} value The selected setter.
 */
org.apache.flex.html.RadioButton.prototype.set_selected =
    function(value) {
  this.input.checked = value;
};


/**
 * @expose
 * @return {Object} The value getter.
 */
org.apache.flex.html.RadioButton.prototype.get_value =
    function() {
  return this.input.value;
};


/**
 * @expose
 * @param {Object} value The value setter.
 */
org.apache.flex.html.RadioButton.prototype.set_value =
    function(value) {
  this.input.value = value;
};


/**
 * @expose
 * @return {Object} The value of the selected RadioButton.
 */
org.apache.flex.html.RadioButton.prototype.get_selectedValue =
    function() {
  var buttons, groupName, i, n;

  groupName = this.input.name;
  buttons = document.getElementsByName(groupName);
  n = buttons.length;

  for (i = 0; i < n; i++) {
    if (buttons[i].checked) {
      return buttons[i].value;
    }
  }
  return null;
};


/**
 * @expose
 * @param {Object} value The value of the selected RadioButton.
 */
org.apache.flex.html.RadioButton.prototype.set_selectedValue =
    function(value) {
  var buttons, groupName, i, n;

  groupName = this.input.name;
  buttons = document.getElementsByName(groupName);
  n = buttons.length;
  for (i = 0; i < n; i++) {
    if (buttons[i].value === value) {
      buttons[i].checked = true;
      break;
    }
  }
};
