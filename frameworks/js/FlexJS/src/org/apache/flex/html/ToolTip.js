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

goog.provide('org_apache_flex_html_ToolTip');

goog.require('org_apache_flex_html_Label');



/**
 * @constructor
 * @extends {org_apache_flex_html_Label}
 */
org_apache_flex_html_ToolTip = function() {
  org_apache_flex_html_ToolTip.base(this, 'constructor');
  this.element.className = 'ToolTip';
};
goog.inherits(org_apache_flex_html_ToolTip,
    org_apache_flex_html_Label);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_ToolTip.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ToolTip',
                qName: 'org_apache_flex_html_ToolTip' }]};
