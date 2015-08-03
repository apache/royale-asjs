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
  this.element.className = 'RadioButton';
  this.typeNames = 'RadioButton';

  this.positioner = this.element;
  this.input.flexjs_wrapper = this;
  this.element.flexjs_wrapper = this;
  this.textNode.flexjs_wrapper = this;

  return this.element;
};


/**
 * @export
 */
org.apache.flex.html.RadioButton.prototype.initModel =
    function() {
};


/**
 * @export
 */
org.apache.flex.html.RadioButton.prototype.initSkin =
    function() {
};


Object.defineProperties(org.apache.flex.html.RadioButton.prototype, {
    /** @export */
    id: {
        /** @this {org.apache.flex.html.RadioButton} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(org.apache.flex.html.RadioButton, this, 'id', value);
            this.labelFor.id = value;
            this.input.id = value;
        }
    },
    /** @export */
    groupName: {
        /** @this {org.apache.flex.html.RadioButton} */
        get: function() {
            return this.input.name;
        },
        /** @this {org.apache.flex.html.RadioButton} */
        set: function(value) {
            this.input.name = value;
        }
    },
    /** @export */
    text: {
        /** @this {org.apache.flex.html.RadioButton} */
        get: function() {
            return this.textNode.nodeValue;
        },
        /** @this {org.apache.flex.html.RadioButton} */
        set: function(value) {
            this.textNode.nodeValue = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.html.RadioButton} */
        get: function() {
            return this.input.checked;
        },
        /** @this {org.apache.flex.html.RadioButton} */
        set: function(value) {
            this.input.checked = value;
        }
    },
    /** @export */
    value: {
        /** @this {org.apache.flex.html.RadioButton} */
        get: function() {
            return this.input.value;
        },
        /** @this {org.apache.flex.html.RadioButton} */
        set: function(value) {
            this.input.value = value;
        }
    },
    /** @export */
    selectedValue: {
        /** @this {org.apache.flex.html.RadioButton} */
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
        /** @this {org.apache.flex.html.RadioButton} */
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
