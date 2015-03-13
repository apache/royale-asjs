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

goog.provide('org_apache_flex_html_beads_layouts_NonVirtualBasicScrollingLayout');

goog.require('org_apache_flex_core_IBeadLayout');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadLayout}
 */
org_apache_flex_html_beads_layouts_NonVirtualBasicScrollingLayout =
    function() {
  this.strand_ = null;
  this.className = 'NonVirtualBasicScrollingLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_layouts_NonVirtualBasicScrollingLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NonVirtualBasicScrollingLayout',
                qName: 'org_apache_flex_html_beads_layouts_NonVirtualBasicScrollingLayout'}],
      interfaces: [org_apache_flex_core_IBeadLayout] };


Object.defineProperties(org_apache_flex_html_beads_layouts_NonVirtualBasicScrollingLayout.prototype, {
    'strand': {
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
              this.strand_.addEventListener('childrenAdded',
                  goog.bind(this.changeHandler, this));
              this.strand_.addEventListener('layoutNeeded',
                  goog.bind(this.changeHandler, this));
            }
        }
    }
});


/**
 * @param {org_apache_flex_events_Event} event The text getter.
 */
org_apache_flex_html_beads_layouts_NonVirtualBasicScrollingLayout.
    prototype.changeHandler = function(event) {
  var i, n, h, w;

  var viewBead = this.strand_.getBeadByType(org_apache_flex_core_ILayoutParent);
  var contentView = viewBead.contentView;
  contentView.element.style.overflow = 'auto';
  w = contentView.width;
  h = contentView.height;
  n = contentView.numElements;
  for (i = 0; i < n; i++) {
    var child = contentView.getElementAt(i);
    var left = org_apache_flex_core_ValuesManager.valuesImpl.getValue(child, 'left');
    var right = org_apache_flex_core_ValuesManager.valuesImpl.getValue(child, 'right');
    var top = org_apache_flex_core_ValuesManager.valuesImpl.getValue(child, 'top');
    var bottom = org_apache_flex_core_ValuesManager.valuesImpl.getValue(child, 'bottom');

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
    child.dispatchEvent('sizeChanged');
  }
};
