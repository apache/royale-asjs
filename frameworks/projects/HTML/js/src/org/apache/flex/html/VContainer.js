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

goog.provide('org_apache_flex_html_VContainer');

goog.require('org_apache_flex_core_IContainer');
goog.require('org_apache_flex_html_Container');



/**
 * @constructor
 * @implements {org_apache_flex_core_IContainer}
 * @extends {org_apache_flex_html_Container}
 */
org_apache_flex_html_VContainer = function() {
  org_apache_flex_html_VContainer.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_VContainer,
    org_apache_flex_html_Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_VContainer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'VContainer',
                qName: 'org_apache_flex_html_VContainer' }],
      interfaces: [org_apache_flex_core_IContainer] };
