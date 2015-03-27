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

goog.provide('org_apache_flex_html5_TextButton');

goog.require('org_apache_flex_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html5_TextButton = function() {
  org_apache_flex_html5_TextButton.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html5_TextButton,
    org_apache_flex_core_UIBase);


/**
 * @override
 */
org_apache_flex_html5_TextButton.prototype.createElement =
    function() {
  this.element = document.createElement('button');
  this.element.setAttribute('type', 'button');

  this.positioner = this.element;

  return this.element;
};


Object.defineProperties(org_apache_flex_html5_TextButton.prototype, {
    'text': {
        /** @this {org_apache_flex_html5_TextButton} */
        get: function() {
            return this.element.innerHTML;
        },
        /** @this {org_apache_flex_html5_TextButton} */
        set: function(value) {
            this.element.innerHTML = value;
        }
    }
});
