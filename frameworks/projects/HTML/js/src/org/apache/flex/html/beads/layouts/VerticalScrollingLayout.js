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

goog.provide('org_apache_flex_html_beads_layouts_VerticalScrollingLayout');

goog.require('org_apache_flex_core_IBeadLayout');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadLayout}
 */
org_apache_flex_html_beads_layouts_VerticalScrollingLayout = function() {
  this.strand_ = null;
  this.className = 'VerticalScrollingLayout';
};


/**
 */
org_apache_flex_html_beads_layouts_VerticalScrollingLayout.
    prototype.layout = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_layouts_VerticalScrollingLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'VerticalScrollingLayout',
                qName: 'org_apache_flex_html_beads_layouts_VerticalScrollingLayout' }],
      interfaces: [org_apache_flex_core_IBeadLayout] };


Object.defineProperties(org_apache_flex_html_beads_layouts_VerticalScrollingLayout.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_layouts_VerticalScrollingLayout} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
            }
        }
    }
});
