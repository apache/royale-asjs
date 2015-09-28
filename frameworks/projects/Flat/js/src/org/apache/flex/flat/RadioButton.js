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

goog.provide('org.apache.flex.flat.RadioButton');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.flat.RadioButton = function() {
  org.apache.flex.flat.RadioButton.base(this, 'constructor');
};
goog.inherits(org.apache.flex.flat.RadioButton,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.flat.RadioButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'RadioButton',
                qName: 'org.apache.flex.flat.RadioButton'}] };


/**
 * Provides unique name
 */
org.apache.flex.flat.RadioButton.radioCounter = 0;


/**
 * @override
 */
org.apache.flex.flat.RadioButton.prototype.createElement =
    function() {

  // hide this eleement
  this.input = document.createElement('input');
  this.input.type = 'radio';
  this.input.className = 'radio-input';
  this.input.id = '_radio_' + org.apache.flex.flat.RadioButton.radioCounter++;
  this.input.addEventListener('change', goog.bind(this.selectionChangeHandler, this));

  this.radio = document.createElement('span');
  this.radio.className = 'radio-icon';
  this.radio.addEventListener('mouseover', goog.bind(this.mouseOverHandler, this));
  this.radio.addEventListener('mouseout', goog.bind(this.mouseOutHandler, this));

  this.textNode = document.createTextNode('radio button');

  this.labelFor = document.createElement('label');
  this.labelFor.appendChild(this.input);
  this.labelFor.appendChild(this.radio);
  this.labelFor.appendChild(this.textNode);
  this.labelFor.style.position = 'relative';

  this.element = this.labelFor;
  this.element.className = 'RadioButton';
  this.typeNames = 'RadioButton';

  this.positioner = this.element;
  this.positioner.style.position = 'relative';
  this.input.flexjs_wrapper = this;
  this.radio.flexjs_wrapper = this;
  this.element.flexjs_wrapper = this;
  this.textNode.flexjs_wrapper = this;

  return this.element;
};


/**
 * @param {Event} e The event object.
 */
org.apache.flex.flat.RadioButton.prototype.mouseOverHandler =
    function(e) {
  this.radio.className = 'radio-icon-hover';
};


/**
 * @param {Event} e The event object.
 */
org.apache.flex.flat.RadioButton.prototype.mouseOutHandler =
    function(e) {
  if (this.input.checked)
    this.radio.className = 'radio-icon-checked';
  else
    this.radio.className = 'radio-icon';
};


/**
 * @param {Event} e The event object.
 */
org.apache.flex.flat.RadioButton.prototype.selectionChangeHandler =
    function(e) {
  // this should reset the icons in the non-selected radio
  this.selectedValue = this.value;
};


/**
 * @export
 */
org.apache.flex.flat.RadioButton.prototype.initModel =
    function() {
};


/**
 * @export
 */
org.apache.flex.flat.RadioButton.prototype.initSkin =
    function() {
};


Object.defineProperties(org.apache.flex.flat.RadioButton.prototype, {
    /** @export */
    id: {
        /** @this {org.apache.flex.flat.RadioButton} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(org.apache.flex.flat.RadioButton, this, 'id', value);
            this.labelFor.id = value;
            this.input.id = value;
        }
    },
    /** @export */
    groupName: {
        /** @this {org.apache.flex.flat.RadioButton} */
        get: function() {
            return this.input.name;
        },
        /** @this {org.apache.flex.flat.RadioButton} */
        set: function(value) {
            this.input.name = value;
        }
    },
    /** @export */
    text: {
        /** @this {org.apache.flex.flat.RadioButton} */
        get: function() {
            return this.textNode.nodeValue;
        },
        /** @this {org.apache.flex.flat.RadioButton} */
        set: function(value) {
            this.textNode.nodeValue = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.flat.RadioButton} */
        get: function() {
            return this.input.checked;
        },
        /** @this {org.apache.flex.flat.RadioButton} */
        set: function(value) {
            this.input.checked = value;
            if (this.input.checked)
              this.radio.className = 'radio-icon-checked';
            else
              this.radio.className = 'radio-icon';
        }
    },
    /** @export */
    value: {
        /** @this {org.apache.flex.flat.RadioButton} */
        get: function() {
            return this.input.value;
        },
        /** @this {org.apache.flex.flat.RadioButton} */
        set: function(value) {
            this.input.value = value;
        }
    },
    /** @export */
    selectedValue: {
        /** @this {org.apache.flex.flat.RadioButton} */
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
        /** @this {org.apache.flex.flat.RadioButton} */
        set: function(value) {
            var buttons, groupName, i, n;

            groupName = this.input.name;
            buttons = document.getElementsByName(groupName);
            n = buttons.length;
            for (i = 0; i < n; i++) {
              if (buttons[i].value === value) {
                buttons[i].checked = true;
                buttons[i].flexjs_wrapper.selected = true;
              }
              else
                buttons[i].flexjs_wrapper.selected = false;
            }
        }
    }
});
