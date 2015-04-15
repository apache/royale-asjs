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

goog.provide('org_apache_flex_html_SimpleAlert');

goog.require('org_apache_flex_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_SimpleAlert = function() {
  org_apache_flex_html_SimpleAlert.base(this, 'constructor');

};
goog.inherits(org_apache_flex_html_SimpleAlert,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_SimpleAlert.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleAlert',
                qName: 'org_apache_flex_html_SimpleAlert'}] };


/**
 * @param {string} message The message to display in the alert.
 * @param {Object} host The host that should display the alert.
 */
org_apache_flex_html_SimpleAlert.show =
    function(message, host) {

  alert(message);
};
