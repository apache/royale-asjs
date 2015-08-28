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

goog.provide('org.apache.flex.html.beads.layouts.HorizontalLayout');

goog.require('org.apache.flex.core.IBeadLayout');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.HorizontalLayout =
    function() {
  this.strand_ = null;
  this.className = 'HorizontalLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.HorizontalLayout.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HorizontalLayout',
                qName: 'org.apache.flex.html.beads.layouts.HorizontalLayout' }],
      interfaces: [org.apache.flex.core.IBeadLayout] };


Object.defineProperties(org.apache.flex.html.beads.layouts.HorizontalLayout.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.layouts.HorizontalLayout} */
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
org.apache.flex.html.beads.layouts.HorizontalLayout.
    prototype.layout = function() {
  var children, i, n;

  var viewBead = this.strand_.getBeadByType(org.apache.flex.core.ILayoutParent);
  var contentView = viewBead.contentView;
  children = contentView.internalChildren();
  var hasHeight = !this.strand_.isHeightSizedToContent();
  var hasWidth = !this.strand_.isWidthSizedToContent();
  var maxHeight = 0;
  var computedWidth = 0;
  n = children.length;
  for (i = 0; i < n; i++)
  {
    var child = children[i];
    child.flexjs_wrapper.internalDisplay = 'inline-block';
    if (child.style.display == 'none')
      child.lastDisplay_ = 'inline-block';
    else
      child.style.display = 'inline-block';
    maxHeight = Math.max(maxHeight, child.offsetHeight);
    if (!hasWidth) {
      var cv = window.getComputedStyle(child);
      var mls = cv['margin-left'];
      var ml = Number(mls.substring(0, mls.length - 2));
      var mrs = cv['margin-right'];
      var mr = Number(mrs.substring(0, mrs.length - 2));
      computedWidth += ml + child.offsetWidth + mr;
    }
    child.flexjs_wrapper.dispatchEvent('sizeChanged');
  }
  // if there are children and maxHeight is ok, use it.
  // maxHeight can be NaN if the child hasn't been rendered yet.
  if (!hasHeight && n > 0 && !isNaN(maxHeight)) {
    contentView.height = maxHeight;
  }
  if (!hasWidth && n > 0 && !isNaN(computedWidth)) {
    contentView.width = computedWidth + 1; // some browser need one more pixel
  }
};
