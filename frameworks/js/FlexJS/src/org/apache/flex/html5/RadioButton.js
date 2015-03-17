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

goog.provide('org_apache_flex_html5_RadioButton');

goog.require('org_apache_flex_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html5_RadioButton = function() {
  org_apache_flex_html5_RadioButton.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html5_RadioButton,
    org_apache_flex_core_UIBase);


/**
 * @override
 */
org_apache_flex_html5_RadioButton.prototype.createElement =
    function() {
  var rb;

  this.element = document.createElement('label');

  rb = document.createElement('input');
  rb.type = 'radio';
  this.element.appendChild(rb);
  this.element.appendChild(document.createTextNode('radio button'));

  this.positioner = this.element;

  return this.element;
};


Object.defineProperties(org_apache_flex_html5_RadioButton.prototype, {
    'groupName': {
 		/** @this {org_apache_flex_html5_RadioButton} */
        get: function() {
            return this.element.childNodes.item(0).name;
		},
 		/** @this {org_apache_flex_html5_RadioButton} */
		set: function(value) {
            this.element.childNodes.item(0).name = value;
		}
	},
    'text' : {
 		/** @this {org_apache_flex_html5_RadioButton} */
        get: function() {
            return this.element.childNodes.item(1).nodeValue;
		},
 		/** @this {org_apache_flex_html5_RadioButton} */
        set: function(value) {
            this.element.childNodes.item(1).nodeValue = value;
		}
	},
	'selected': {
 		/** @this {org_apache_flex_html5_RadioButton} */
        get: function() {
            return this.element.childNodes.item(0).checked;
		},
 		/** @this {org_apache_flex_html5_RadioButton} */
		set: function(value) {
            this.element.childNodes.item(0).checked = value;
		}
	}
});
