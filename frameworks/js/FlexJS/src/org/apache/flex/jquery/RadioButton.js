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

  goog.base(this);

  org.apache.flex.core.UIBase.call(this);
  org.apache.flex.jquery.RadioButton.radioCounter++;
};
goog.inherits(org.apache.flex.jquery.RadioButton,
    org.apache.flex.core.UIBase);


/**
 * @expose
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

  var input = document.createElement('input');
  input.type = 'radio';
  input.name = 'radio';
  input.id = 'radio' +
      org.apache.flex.jquery.RadioButton.radioCounter;

  var label = document.createElement('label');
  label.htmlFor = input.id;

  this.element = input;
  this.labelFor = label;

  this.positioner = this.element;
  this.flexjs_wrapper = this;
};


/**
 * @override
 * @param {Object} doc the document for this item.
 */
org.apache.flex.jquery.RadioButton.prototype.setDocument =
    function(doc, id) {
  if (!org.apache.flex.jquery.RadioButton.groupHandlerSet)
  {
    org.apache.flex.jquery.RadioButton.groupHandlerSet =
        true;
    doc.addEventListener('initComplete',
        goog.bind(this.initHandler, this));
  }
};


/**
 * @param {Event} event The event.
 */
org.apache.flex.jquery.RadioButton.prototype.initHandler =
    function(event) {
  var divtags = org.apache.flex.jquery.RadioButton.groups;
  for (var name in divtags)
  {
    var div = divtags[name];
    $(div).buttonset();
  }
};


/**
 * @expose
 * @return {string} The groupName getter.
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

  /*
 * NOTE: Ideally when a RadioButton was created it would be added to an
 * existing set of RadioButtons. This is especially true for RadioButtons
 * added dynamically. However, due to a bug in jQuery
 * (see http://bugs.jqueryui.com/ticket/8975), it is currently not possible
 * to add or remove RadioButtons programmatically. For this version the
 * groups are maintained here in RadioButton and once the application has
 * finished initializing, the groups are given their buttonset().
 */

  this.radioGroupName = value;

  this.element.name = value;

  var div;

  if (org.apache.flex.jquery.RadioButton.groups[value]) {
    div = org.apache.flex.jquery.RadioButton.groups[value];
    div.appendChild(this.element);
    div.appendChild(this.labelFor);
  }
  else {
    div = document.createElement('div');
    div.id = value;
    div.appendChild(this.element);
    div.appendChild(this.labelFor);

    org.apache.flex.jquery.
        RadioButton.groups[String(value)] = div;
  }

  this.positioner = div;
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
 * @return {bool} The selected getter.
 */
org.apache.flex.jquery.RadioButton.prototype.get_selected =
    function() {
  return this.element.checked;
};


/**
 * @expose
 * @param {bool} value The selected setter.
 */
org.apache.flex.jquery.RadioButton.prototype.set_selected =
    function(value) {
  this.element.checked = value;
};
