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

goog.provide('org_apache_flex_jquery_ToggleTextButton');

goog.require('org_apache_flex_html_Button');
goog.require('org_apache_flex_utils_Language');



/**
 * @constructor
 * @extends {org_apache_flex_html_Button}
 */
org_apache_flex_jquery_ToggleTextButton = function() {
  org_apache_flex_jquery_ToggleTextButton.base(this, 'constructor');



  /**
   * @private
   * @type {boolean}
   */
  this.selected_ = false;
};
goog.inherits(org_apache_flex_jquery_ToggleTextButton,
    org_apache_flex_html_Button);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_jquery_ToggleTextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ToggleTextButton',
                qName: 'org_apache_flex_jquery_ToggleTextButton'}] };


/**
 * @expose
 * Used to provide ids to the ToggleTextButton.
 */
org_apache_flex_jquery_ToggleTextButton.toggleCounter = 0;


/**
 * @override
 */
org_apache_flex_jquery_ToggleTextButton.prototype.createElement =
    function() {

  // the radio itself
  this.input = document.createElement('input');
  this.input.type = 'checkbox';
  this.input.name = 'checkbox';
  this.input.id = '_toggle_' + org_apache_flex_jquery_ToggleTextButton.toggleCounter++;

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
org_apache_flex_jquery_ToggleTextButton.prototype.addedToParent =
    function() {
  org_apache_flex_jquery_ToggleTextButton.base(this, 'addedToParent');
  $(this.element).button();
};


Object.defineProperties(org_apache_flex_jquery_ToggleTextButton.prototype, {
    'id': {
 		/** @this {org_apache_flex_jquery_ToggleTextButton} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(org_apache_flex_jquery_ToggleTextButton.base, this, 'id', value);
            this.labelFor.id = value;
            this.labelFor.htmlFor = value;
        }
    },
    'text': {
 		/** @this {org_apache_flex_jquery_ToggleTextButton} */
        get: function() {
            return this.labelFor.innerHTML;
        },
 		/** @this {org_apache_flex_jquery_ToggleTextButton} */
        set: function(value) {
            this.labelFor.innerHTML = value;
        }
    },
    'selected': {
 		/** @this {org_apache_flex_jquery_ToggleTextButton} */
        get: function() {
            return this.input.selected_;
        },
 		/** @this {org_apache_flex_jquery_ToggleTextButton} */
        set: function(value) {
            if (this.input.selected_ != value) {
            this.inputselected_ = value;
            /*
              var className = this.className;
              if (value) {
                if (className.indexOf(this.SELECTED) == className.length - this.SELECTED.length)
                  this.className = className.substring(0, className.length - this.SELECTED.length);
              }
              else {
                if (className.indexOf(this.SELECTED) == -1)
                  this.className = className + this.SELECTED;
              }
             */
            }
        }
    }
});


/**
 * @type {string} The selected setter.
 */
org_apache_flex_jquery_ToggleTextButton.prototype.SELECTED = '_Selected';

