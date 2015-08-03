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

goog.provide('org.apache.flex.flat.CheckBox');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.flat.CheckBox = function() {
  org.apache.flex.flat.CheckBox.base(this, 'constructor');
};
goog.inherits(org.apache.flex.flat.CheckBox,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.flat.CheckBox.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'CheckBox',
                qName: 'org.apache.flex.flat.CheckBox'}] };


/**
 * @override
 */
org.apache.flex.flat.CheckBox.prototype.createElement =
    function() {
  var cb;

  this.element = document.createElement('label');

  this.input = document.createElement('input');
  this.input.type = 'checkbox';
  this.input.className = 'checkbox-input';
  this.input.addEventListener('change', goog.bind(this.selectionChangeHandler, this));
  this.element.appendChild(this.input);

  this.checkbox = document.createElement('span');
  this.checkbox.className = 'checkbox-icon';
  this.checkbox.addEventListener('mouseover', goog.bind(this.mouseOverHandler, this));
  this.checkbox.addEventListener('mouseout', goog.bind(this.mouseOutHandler, this));
  this.element.appendChild(this.checkbox);

  this.textNode = document.createTextNode('');
  this.element.appendChild(this.textNode);
  this.element.className = 'CheckBox';
  this.typeNames = 'CheckBox';

  this.positioner = this.element;
  this.input.flexjs_wrapper = this;
  this.checkbox.flexjs_wrapper = this;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @param {Event} e The event object.
 */
org.apache.flex.flat.CheckBox.prototype.mouseOverHandler =
    function(e) {
  this.checkbox.className = 'checkbox-icon-hover';
};


/**
 * @param {Event} e The event object.
 */
org.apache.flex.flat.CheckBox.prototype.mouseOutHandler =
    function(e) {
  if (this.input.checked)
    this.checkbox.className = 'checkbox-icon-checked';
  else
    this.checkbox.className = 'checkbox-icon';
};


/**
 * @param {Event} e The event object.
 */
org.apache.flex.flat.CheckBox.prototype.selectionChangeHandler =
    function(e) {
  if (this.input.checked)
    this.checkbox.className = 'checkbox-icon-checked';
  else
    this.checkbox.className = 'checkbox-icon';
};


Object.defineProperties(org.apache.flex.flat.CheckBox.prototype, {
    /** @export */
    text: {
        /** @this {org.apache.flex.flat.CheckBox} */
        get: function() {
            return this.textNode.nodeValue;
        },
        /** @this {org.apache.flex.flat.CheckBox} */
        set: function(value) {
            this.textNode.nodeValue = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.flat.CheckBox} */
        get: function() {
            return this.input.checked;
        },
        /** @this {org.apache.flex.flat.CheckBox} */
        set: function(value) {
            this.input.checked = value;
            if (value)
              this.checkbox.className = 'checkbox-icon-checked';
            else
              this.checkbox.className = 'checkbox-icon';
        }
    }
});
