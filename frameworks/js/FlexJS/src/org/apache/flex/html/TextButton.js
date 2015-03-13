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

goog.provide('org_apache_flex_html_TextButton');

goog.require('org_apache_flex_html_Button');



/**
 * @constructor
 * @extends {org_apache_flex_html_Button}
 */
org_apache_flex_html_TextButton = function() {
  org_apache_flex_html_TextButton.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_TextButton,
    org_apache_flex_html_Button);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_TextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextButton',
                qName: 'org_apache_flex_html_TextButton'}] };


Object.defineProperties(org_apache_flex_html_TextButton.prototype, {
    'text': {
        get: function() {
            return this.element.innerHTML;
        },
        set: function(value) {
            this.element.innerHTML = value;
        }
    }
});
