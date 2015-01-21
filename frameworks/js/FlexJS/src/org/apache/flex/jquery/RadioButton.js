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

goog.provide('org.apache.flex.jquery.RadioButton');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.jquery.RadioButton = function() {

  org.apache.flex.jquery.RadioButton.base(this, 'constructor');

  org.apache.flex.core.UIBase.call(this);
  org.apache.flex.jquery.RadioButton.radioCounter++;
};
goog.inherits(org.apache.flex.jquery.RadioButton,
    org.apache.flex.core.UIBase);


/**
 * @expose
 * @type {?string}
 * The name of the radioGroup.
 */
org.apache.flex.jquery.RadioButton.prototype.radioGroupName = null;


/**
 * @expose
 * Used to provide ids to the radio buttons.
 */
org.apache.flex.jquery.RadioButton.radioCounter = 0;


/**
 * @expose
 * Used to manage groups on the radio buttons.
 */
org.apache.flex.jquery.RadioButton.groups = { };


/**
 * Flag to make sure the event handler is set only once.
 */
org.apache.flex.jquery.RadioButton.groupHandlerSet = false;


/**
 * @override
 */
org.apache.flex.jquery.RadioButton.prototype.createElement =
    function() {

  // the radio itself
  this.input = document.createElement('input');
  this.input.type = 'radio';
  this.input.name = 'radio';
  this.input.id = '_radio_' + org.apache.flex.jquery.RadioButton.radioCounter++;

  this.labelFor = document.createElement('label');
  this.labelFor.htmlFor = this.input.id;

  this.positioner = document.createElement('div');
  this.positioner.appendChild(this.input);
  this.positioner.appendChild(this.labelFor);
  this.element = this.input;

  this.input.flexjs_wrapper = this;
  this.labelFor.flexjs_wrapper = this;
  this.positioner.flexjs_wrapper = this;

  return this.element;
};


/**
 * @override
 */
org.apache.flex.jquery.RadioButton.prototype.addedToParent =
    function() {
  org.apache.flex.jquery.RadioButton.base(this, 'addedToParent');
  $(this.input).button();
};


/**
 * @override
 */
org.apache.flex.jquery.RadioButton.prototype.set_id = function(value) {
  org.apache.flex.jquery.RadioButton.base(this, 'set_id', value);
  this.labelFor.id = value;
  this.labelFor.htmlFor = value;
};


/**
 * @expose
 * @return {?string} The groupName getter.
 */
org.apache.flex.jquery.RadioButton.prototype.get_groupName =
    function() {
  return this.radioGroupName;
};


/**
 * @expose
 * @param {string} value The groupName setter.
 */
org.apache.flex.jquery.RadioButton.prototype.set_groupName =
    function(value) {

  this.radioGroupName = value;
  this.input.name = value;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org.apache.flex.jquery.RadioButton.prototype.get_text =
    function() {
  return this.labelFor.innerHTML;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org.apache.flex.jquery.RadioButton.prototype.set_text =
    function(value) {
  this.labelFor.innerHTML = value;
};


/**
 * @expose
 * @return {boolean} The selected getter.
 */
org.apache.flex.jquery.RadioButton.prototype.get_selected =
    function() {
  return this.input.checked;
};


/**
 * @expose
 * @param {boolean} value The selected setter.
 */
org.apache.flex.jquery.RadioButton.prototype.set_selected =
    function(value) {
  this.input.checked = value;
};


/**
 * @expose
 * @return {Object} The value getter.
 */
org.apache.flex.jquery.RadioButton.prototype.get_value =
    function() {
  return this.input.value;
};


/**
 * @expose
 * @param {Object} value The value setter.
 */
org.apache.flex.jquery.RadioButton.prototype.set_value =
    function(value) {
  this.input.value = value;
};


/**
 * @expose
 * @return {Object} The value of the selected RadioButton.
 */
org.apache.flex.jquery.RadioButton.prototype.get_selectedValue =
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
org.apache.flex.jquery.RadioButton.prototype.set_selectedValue =
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
