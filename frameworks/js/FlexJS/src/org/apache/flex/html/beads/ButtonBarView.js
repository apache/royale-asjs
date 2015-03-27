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

goog.provide('org_apache_flex_html_beads_ButtonBarView');

goog.require('org_apache_flex_html_beads_ListView');
goog.require('org_apache_flex_utils_Language');



/**
 * @constructor
 * @extends {org_apache_flex_html_beads_ListView}
 */
org_apache_flex_html_beads_ButtonBarView = function() {
  this.lastSelectedIndex = -1;
  org_apache_flex_html_beads_ButtonBarView.base(this, 'constructor');

  this.className = 'ButtonBarView';
};
goog.inherits(
    org_apache_flex_html_beads_ButtonBarView,
    org_apache_flex_html_beads_ListView);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_ButtonBarView.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBarView',
                qName: 'org_apache_flex_html_beads_ButtonBarView' }] };


Object.defineProperties(org_apache_flex_html_beads_ButtonBarView.prototype, {
    'strand': {
        /** @this {org_apache_flex_html_beads_ButtonBarView} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(
                org_apache_flex_html_beads_ButtonBarView, this, 'strand', value);
            this.strand_ = value;
        }
    }
});
