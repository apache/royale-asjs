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
goog.require('org.apache.flex.core.ILayoutHost');
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

  var viewBead = this.strand_.getBeadByType(org.apache.flex.core.ILayoutHost);
  var contentView = viewBead.contentView;
  children = contentView.internalChildren();
  var scv = getComputedStyle(this.strand_.positioner);
  var hasWidth = !this.strand_.isWidthSizedToContent();
  var maxWidth = 0;
  n = children.length;
  for (i = 0; i < n; i++)
  {
    var child = children[i];
    child.flexjs_wrapper.internalDisplay = 'block';
    if (child.style.display === 'none') {
      child.lastDisplay_ = 'block';
    } else {
      // block elements don't measure width correctly so set to inline for a second
      child.style.display = 'inline-block';
      maxWidth = Math.max(maxWidth, child.offsetLeft + child.offsetWidth);
      child.style.display = 'block';
    }
    child.flexjs_wrapper.dispatchEvent('sizeChanged');
  }
  if (!hasWidth && n > 0 && !isNaN(maxWidth)) {
    var pl = scv.getPropertyValue('padding-left');
    var pr = scv.getPropertyValue('padding-right');
    pl = parseInt(pl.substring(0, pl.length - 2), 10);
    pr = parseInt(pr.substring(0, pr.length - 2), 10);
    maxWidth += pl + pr;
    contentView.width = maxWidth;
  }
};
