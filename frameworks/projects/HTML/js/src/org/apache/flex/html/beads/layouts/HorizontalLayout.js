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

goog.provide('org_apache_flex_html_beads_layouts_HorizontalLayout');

goog.require('org_apache_flex_core_IBeadLayout');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadLayout}
 */
org_apache_flex_html_beads_layouts_HorizontalLayout =
    function() {
  this.strand_ = null;
  this.className = 'HorizontalLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_layouts_HorizontalLayout.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HorizontalLayout',
                qName: 'org_apache_flex_html_beads_layouts_HorizontalLayout' }],
      interfaces: [org_apache_flex_core_IBeadLayout] };


Object.defineProperties(org_apache_flex_html_beads_layouts_HorizontalLayout.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_layouts_HorizontalLayout} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
              this.strand_.element.style.display = 'block';
            }
        }
    }
});


/**
 */
org_apache_flex_html_beads_layouts_HorizontalLayout.
    prototype.layout = function() {
  var children, i, n;

  children = this.strand_.internalChildren();
  n = children.length;
  for (i = 0; i < n; i++)
  {
    var child = children[i];
    child.internalDisplay = 'inline-block';
    if (child.style.display == 'none')
      child.lastDisplay_ = 'inline-block';
    else
      child.style.display = 'inline-block';
    child.style.verticalAlign = 'middle';
    child.flexjs_wrapper.dispatchEvent('sizeChanged');
  }
};
