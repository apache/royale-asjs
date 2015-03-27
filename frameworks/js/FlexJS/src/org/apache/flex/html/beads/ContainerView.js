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

goog.provide('org_apache_flex_html_beads_ContainerView');

goog.require('org_apache_flex_core_BeadViewBase');
goog.require('org_apache_flex_core_ILayoutParent');



/**
 * @constructor
 * @extends {org_apache_flex_core_BeadViewBase}
 */
org_apache_flex_html_beads_ContainerView = function() {
  this.lastSelectedIndex = -1;
  org_apache_flex_html_beads_ContainerView.base(this, 'constructor');

  this.className = 'ContainerView';
};
goog.inherits(
    org_apache_flex_html_beads_ContainerView,
    org_apache_flex_core_BeadViewBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_ContainerView.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ContainerView',
                qName: 'org_apache_flex_html_beads_ContainerView' }],
    interfaces: [org_apache_flex_core_ILayoutParent]
    };


Object.defineProperties(org_apache_flex_html_beads_ContainerView.prototype, {
    'contentView': {
        /** @this {org_apache_flex_html_beads_ContainerView} */
        get: function() {
            return this._strand;
        }
    },
    'resizableView': {
        /** @this {org_apache_flex_html_beads_ContainerView} */
        get: function() {
            return this._strand;
        }
    }
});
