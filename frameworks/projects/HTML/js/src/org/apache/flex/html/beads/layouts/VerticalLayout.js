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
  this.lastWidth_ = '';
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
        /** @this {org.apache.flex.html.beads.layouts.VerticalLayout} */
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
  var sps = this.strand_.positioner.style;
  var scv = getComputedStyle(this.strand_.positioner);
  var hasWidth = sps.width !== undefined && sps.width != this.lastWidth_;
  var maxWidth = 0;
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
    maxWidth = Math.max(maxWidth, child.offsetLeft + child.offsetWidth);
    child.flexjs_wrapper.dispatchEvent('sizeChanged');
  }
  if (!hasWidth && n > 0 && !isNaN(maxWidth) && (!(scv.left != 'auto' && scv.right != 'auto'))) {
    this.lastWidth_ = sps.width = maxWidth.toString() + 'px';
  }
};
