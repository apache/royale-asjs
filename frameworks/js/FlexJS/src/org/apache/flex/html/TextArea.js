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

goog.provide('org_apache_flex_html_TextArea');

goog.require('org_apache_flex_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_TextArea = function() {
  org_apache_flex_html_TextArea.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_TextArea,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_TextArea.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextArea',
                qName: 'org_apache_flex_html_TextArea'}] };


/**
 * @override
 */
org_apache_flex_html_TextArea.prototype.createElement =
    function() {

  this.element = document.createElement('textarea');
  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org_apache_flex_html_TextArea.prototype.get_text = function() {
  return this.element.value;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org_apache_flex_html_TextArea.prototype.set_text =
    function(value) {
  this.element.value = value;
};
