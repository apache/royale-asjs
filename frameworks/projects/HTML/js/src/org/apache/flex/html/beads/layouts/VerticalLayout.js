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

goog.provide('org.apache.flex.html.beads.layouts.VerticalLayout');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.VerticalLayout =
    function() {
  this.strand_ = null;
  this.className = 'VerticalLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.VerticalLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'VerticalLayout',
                qName: 'org.apache.flex.html.beads.layouts.VerticalLayout'}],
      interfaces: [org.apache.flex.core.IBeadLayout] };


Object.defineProperties(org.apache.flex.html.beads.layouts.VerticalLayout.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.layouts.VerticalLayout} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
            }
        },
        get: function() {
            return this.strand_;
        }
    }
});


/**
 */
org.apache.flex.html.beads.layouts.VerticalLayout.
    prototype.layout = function() {
  var children, i, n;

  children = this.strand_.internalChildren();
  n = children.length;
  for (i = 0; i < n; i++)
  {
    var child = children[i];
    child.internalDisplay = 'block';
    if (child.style.display === 'none') {
      child.lastDisplay_ = 'block';
    } else {
      child.style.display = 'block';
    }
    child.flexjs_wrapper.dispatchEvent('sizeChanged');
  }
};
