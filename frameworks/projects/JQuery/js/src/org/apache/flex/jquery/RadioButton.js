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
goog.require('org.apache.flex.utils.Language');



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
 * @export
 * @type {?string}
 * The name of the radioGroup.
 */
org.apache.flex.jquery.RadioButton.prototype.radioGroupName = null;


/**
 * @export
 * Used to provide ids to the radio buttons.
 */
org.apache.flex.jquery.RadioButton.radioCounter = 0;


/**
 * @export
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


Object.defineProperties(org.apache.flex.jquery.RadioButton.prototype, {
    /** @export */
    id: {
        /** @this {org.apache.flex.jquery.RadioButton} */
        set: function(value) {
            org.apache.flex.utils.Language(org.apache.flex.jquery.RadioButton.base, this, 'id', value);
            this.labelFor.id = value;
            this.labelFor.htmlFor = value;
        }
    },
    /** @export */
    groupName: {
        /** @this {org.apache.flex.jquery.RadioButton} */
        get: function() {
            return this.radioGroupName;
        },
        /** @this {org.apache.flex.jquery.RadioButton} */
        set: function(value) {
           this.radioGroupName = value;
           this.input.name = value;
        }
    },
    /** @export */
    text: {
        /** @this {org.apache.flex.jquery.RadioButton} */
        get: function() {
            return this.labelFor.innerHTML;
        },
        /** @this {org.apache.flex.jquery.RadioButton} */
        set: function(value) {
            this.labelFor.innerHTML = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.jquery.RadioButton} */
        get: function() {
            return this.input.checked;
        },
        /** @this {org.apache.flex.jquery.RadioButton} */
        set: function(value) {
            this.input.checked = value;
        }
    },
    /** @export */
    value: {
        /** @this {org.apache.flex.jquery.RadioButton} */
        get: function() {
            return this.input.value;
        },
        /** @this {org.apache.flex.jquery.RadioButton} */
        set: function(value) {
            this.input.value = value;
        }
    },
    /** @export */
    selectedValue: {
        /** @this {org.apache.flex.jquery.RadioButton} */
        get: function() {
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
        },
        /** @this {org.apache.flex.jquery.RadioButton} */
        set: function(value) {
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
        }
    }
});
