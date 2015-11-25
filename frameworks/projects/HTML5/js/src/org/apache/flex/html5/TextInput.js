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

goog.provide('org.apache.flex.html5.TextInput');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html5.TextInput = function() {
  org.apache.flex.html5.TextInput.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html5.TextInput,
    org.apache.flex.core.UIBase);


/**
 * @override
 */
org.apache.flex.html5.TextInput.prototype.createElement =
    function() {
  this.element = document.createElement('input');
  this.element.setAttribute('type', 'input');

  this.positioner = this.element;
  this.positioner.style.position = 'relative';

  return this.element;
};


Object.defineProperties(org.apache.flex.html5.TextInput.prototype, {
    /** @export */
    text: {
        /** @this {org.apache.flex.html5.TextInput} */
        get: function() {
            return this.element.value;
        },
        /** @this {org.apache.flex.html5.TextInput} */
        set: function(value) {
            this.element.value = value;
        }
    }
});
