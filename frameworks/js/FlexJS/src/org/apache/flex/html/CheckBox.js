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

goog.provide('org_apache_flex_html_CheckBox');

goog.require('org_apache_flex_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_CheckBox = function() {
  org_apache_flex_html_CheckBox.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_CheckBox,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_CheckBox.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'CheckBox',
                qName: 'org_apache_flex_html_CheckBox'}] };


/**
 * @override
 */
org_apache_flex_html_CheckBox.prototype.createElement =
    function() {
  var cb;

  this.element = document.createElement('label');

  cb = document.createElement('input');
  cb.type = 'checkbox';
  this.element.appendChild(cb);
  this.element.appendChild(document.createTextNode(''));

  this.positioner = this.element;
  cb.flexjs_wrapper = this;
  this.element.flexjs_wrapper = this;

  return this.element;
};


Object.defineProperties(org_apache_flex_html_CheckBox.prototype, {
    'text': {
		get: function() {
            return this.element.childNodes.item(1).nodeValue;
		},
        set: function(value) {
            this.element.childNodes.item(1).nodeValue = value;
		}
	},
    'selected': {
		get: function() {
            return this.element.childNodes.item(0).checked;
		},
        set: function(value) {
            this.element.childNodes.item(0).checked = value;
		}
	}
});
