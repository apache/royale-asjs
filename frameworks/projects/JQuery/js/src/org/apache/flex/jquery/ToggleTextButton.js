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

goog.provide('org.apache.flex.jquery.ToggleTextButton');

goog.require('org.apache.flex.html.Button');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.html.Button}
 */
org.apache.flex.jquery.ToggleTextButton = function() {
  org.apache.flex.jquery.ToggleTextButton.base(this, 'constructor');



  /**
   * @private
   * @type {boolean}
   */
  this.selected_ = false;
};
goog.inherits(org.apache.flex.jquery.ToggleTextButton,
    org.apache.flex.html.Button);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.jquery.ToggleTextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ToggleTextButton',
                qName: 'org.apache.flex.jquery.ToggleTextButton'}] };


/**
 * @export
 * Used to provide ids to the ToggleTextButton.
 */
org.apache.flex.jquery.ToggleTextButton.toggleCounter = 0;


/**
 * @override
 */
org.apache.flex.jquery.ToggleTextButton.prototype.createElement =
    function() {

  // the radio itself
  this.input = document.createElement('input');
  this.input.type = 'checkbox';
  this.input.name = 'checkbox';
  this.input.id = '_toggle_' + org.apache.flex.jquery.ToggleTextButton.toggleCounter++;

  this.labelFor = document.createElement('label');
  this.labelFor.htmlFor = this.input.id;

  this.positioner = document.createElement('div');
  this.positioner.style.position = 'relative';
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
org.apache.flex.jquery.ToggleTextButton.prototype.addedToParent =
    function() {
  org.apache.flex.jquery.ToggleTextButton.base(this, 'addedToParent');
  $(this.element).button();
};


Object.defineProperties(org.apache.flex.jquery.ToggleTextButton.prototype, {
    /** @export */
    id: {
        /** @this {org.apache.flex.jquery.ToggleTextButton} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(org.apache.flex.jquery.ToggleTextButton.base, this, 'id', value);
            this.labelFor.id = value;
            this.labelFor.htmlFor = value;
        }
    },
    /** @export */
    text: {
        /** @this {org.apache.flex.jquery.ToggleTextButton} */
        get: function() {
            return this.labelFor.innerHTML;
        },
        /** @this {org.apache.flex.jquery.ToggleTextButton} */
        set: function(value) {
            this.labelFor.innerHTML = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.jquery.ToggleTextButton} */
        get: function() {
            return this.input.selected_;
        },
        /** @this {org.apache.flex.jquery.ToggleTextButton} */
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
org.apache.flex.jquery.ToggleTextButton.prototype.SELECTED = '_Selected';

