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

goog.provide('org_apache_flex_html5_CheckBox');

goog.require('org_apache_flex_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html5_CheckBox = function() {
  org_apache_flex_html5_CheckBox.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html5_CheckBox,
    org_apache_flex_core_UIBase);


/**
 * @override
 */
org_apache_flex_html5_CheckBox.prototype.createElement =
    function() {
  var cb;

  this.element = document.createElement('label');

  cb = document.createElement('input');
  cb.type = 'checkbox';
  this.element.appendChild(cb);
  this.element.appendChild(document.createTextNode('check box'));

  this.positioner = this.element;

  return this.element;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org_apache_flex_html5_CheckBox.prototype.get_text = function() {
  return this.element.childNodes.item(1).nodeValue;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org_apache_flex_html5_CheckBox.prototype.set_text =
    function(value) {
  this.element.childNodes.item(1).nodeValue = value;
};


/**
 * @expose
 * @return {boolean} The selected getter.
 */
org_apache_flex_html5_CheckBox.prototype.get_selected =
    function() {
  return this.element.childNodes.item(0).checked;
};


/**
 * @expose
 * @param {boolean} value The selected setter.
 */
org_apache_flex_html5_CheckBox.prototype.set_selected =
    function(value) {
  this.element.childNodes.item(0).checked = value;
};
