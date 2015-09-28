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

goog.provide('org.apache.flex.html.CheckBox');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.CheckBox = function() {
  org.apache.flex.html.CheckBox.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.CheckBox,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.CheckBox.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'CheckBox',
                qName: 'org.apache.flex.html.CheckBox'}] };


/**
 * @override
 */
org.apache.flex.html.CheckBox.prototype.createElement =
    function() {
  var cb;

  this.element = document.createElement('label');

  cb = document.createElement('input');
  cb.type = 'checkbox';
  this.element.appendChild(cb);
  this.element.appendChild(document.createTextNode(''));

  this.element.className = 'CheckBox';
  this.typeNames = 'CheckBox';

  this.positioner = this.element;
  this.positioner.style.position = 'relative';
  cb.flexjs_wrapper = this;
  this.element.flexjs_wrapper = this;

  return this.element;
};


Object.defineProperties(org.apache.flex.html.CheckBox.prototype, {
    /** @export */
    text: {
        /** @this {org.apache.flex.html.CheckBox} */
        get: function() {
            return this.element.childNodes.item(1).nodeValue;
        },
        /** @this {org.apache.flex.html.CheckBox} */
        set: function(value) {
            this.element.childNodes.item(1).nodeValue = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.html.CheckBox} */
        get: function() {
            return this.element.childNodes.item(0).checked;
        },
        /** @this {org.apache.flex.html.CheckBox} */
        set: function(value) {
            this.element.childNodes.item(0).checked = value;
        }
    }
});
