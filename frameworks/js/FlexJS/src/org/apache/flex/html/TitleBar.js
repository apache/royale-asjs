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

goog.provide('org_apache_flex_html_TitleBar');

goog.require('org_apache_flex_html_Container');
goog.require('org_apache_flex_html_Label');
goog.require('org_apache_flex_html_TextButton');
goog.require('org_apache_flex_html_beads_models_TitleBarModel');



/**
 * @constructor
 * @extends {org_apache_flex_html_Container}
 */
org_apache_flex_html_TitleBar = function() {

  org_apache_flex_html_TitleBar.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_TitleBar,
    org_apache_flex_html_Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_TitleBar.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TitleBar',
                qName: 'org_apache_flex_html_TitleBar'}] };


/**
 * @override
 */
org_apache_flex_html_TitleBar.prototype.createElement =
    function() {

  this.element = document.createElement('div');

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  this.className = 'TitleBar';

  return this.element;
};


Object.defineProperties(org_apache_flex_html_TitleBar.prototype, {
    'title': {
        /** @this {org_apache_flex_html_TitleBar} */
        get: function() {
            return this.model.title;
        },
        /** @this {org_apache_flex_html_TitleBar} */
        set: function(value) {
            this.model.title = value;
        }
    },
    'showCloseButton': {
        /** @this {org_apache_flex_html_TitleBar} */
        get: function() {
            return this.model.showCloseButton;
        },
        /** @this {org_apache_flex_html_TitleBar} */
        set: function(value) {
            this.model.showCloseButton = value;
        }
    }
});
