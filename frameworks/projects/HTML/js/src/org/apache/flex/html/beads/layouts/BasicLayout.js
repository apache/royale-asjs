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

goog.provide('org.apache.flex.html.beads.layouts.BasicLayout');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.core.ILayoutChild');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.BasicLayout =
    function() {
  this.strand_ = null;
  this.className = 'BasicLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.BasicLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BasicLayout',
                qName: 'org.apache.flex.html.beads.layouts.BasicLayout'}],
      interfaces: [org.apache.flex.core.IBeadLayout] };


Object.defineProperties(org.apache.flex.html.beads.layouts.BasicLayout.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.layouts.BasicLayout} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
            }
        }
    }
});


/**
 */
org.apache.flex.html.beads.layouts.BasicLayout.
    prototype.layout = function() {
  var i, n, h, w;

  var viewBead = this.strand_.getBeadByType(org.apache.flex.core.ILayoutParent);
  var contentView = viewBead.contentView;
  w = contentView.width;
  h = contentView.height;
  n = contentView.numElements;
  for (i = 0; i < n; i++) {
    var child = contentView.getElementAt(i);
    child.positioner.internalDisplay = 'block';
    var left = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'left');
    var right = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'right');
    var top = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'top');
    var bottom = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'bottom');
    var margin = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'margin');
    var marginLeft = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'margin-left');
    var marginRight = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'margin-right');
    var horizontalCenter =
        (marginLeft == 'auto' && marginRight == 'auto') ||
          (typeof(margin) === 'string' && margin == 'auto') ||
          (margin && margin.hasOwnProperty('length') &&
            ((margin.length < 4 && margin[1] == 'auto') ||
            (margin.length == 4 && margin[1] == 'auto' && margin[3] == 'auto')));

    if (!isNaN(left)) {
      child.positioner.style.position = 'absolute';
      child.positioner.style.left = left.toString() + 'px';
    }
    if (!isNaN(top)) {
      child.positioner.style.position = 'absolute';
      child.positioner.style.top = top.toString() + 'px';
    }
    if (!isNaN(right)) {
      child.positioner.style.position = 'absolute';
      child.positioner.style.right = right.toString() + 'px';
    }
    if (!isNaN(bottom)) {
      child.positioner.style.position = 'absolute';
      child.positioner.style.bottom = bottom.toString() + 'px';
    }
    if (horizontalCenter)
    {
      child.positioner.style.position = 'absolute';
      child.positioner.style.left = ((w - child.width) / 2).toString() + 'px';
    }
    child.dispatchEvent('sizeChanged');
  }
};
