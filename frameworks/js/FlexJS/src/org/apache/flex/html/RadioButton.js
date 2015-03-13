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

goog.provide('org_apache_flex_html_RadioButton');

goog.require('org_apache_flex_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_RadioButton = function() {
  org_apache_flex_html_RadioButton.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_RadioButton,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_RadioButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'RadioButton',
                qName: 'org_apache_flex_html_RadioButton'}] };


/**
 * Provides unique name
 */
org_apache_flex_html_RadioButton.radioCounter = 0;


/**
 * @override
 */
org_apache_flex_html_RadioButton.prototype.createElement =
    function() {

  this.input = document.createElement('input');
  this.input.type = 'radio';
  this.input.id = '_radio_' + org_apache_flex_html_RadioButton.radioCounter++;

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
org_apache_flex_html_RadioButton.prototype.initModel =
    function() {
};


/**
 * @expose
 */
org_apache_flex_html_RadioButton.prototype.initSkin =
    function() {
};


Object.defineProperties(org_apache_flex_html_RadioButton.prototype, {
    'id': {
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(org_apache_flex_html_RadioButton, this, 'id', value);
            this.labelFor.id = value;
            this.input.id = value;
        }
    },
    'groupName': {
        get: function() {
            return this.input.name;
        },
        set: function(value) {
            this.input.name = value;
        }
    },
    'text': {
        get: function() {
            return this.textNode.nodeValue;
        },
        set: function(value) {
            this.textNode.nodeValue = value;
        }
    },
    'selected': {
        get: function() {
            return this.input.checked;
        },
        set: function(value) {
            this.input.checked = value;
        }
    },
    'value': {
        get: function() {
            return this.input.value;
        },
        set: function(value) {
            this.input.value = value;
        }
    },
    'selectedValue': {
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
