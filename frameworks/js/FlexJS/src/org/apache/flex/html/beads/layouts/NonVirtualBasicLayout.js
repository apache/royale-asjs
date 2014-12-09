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

goog.provide('org.apache.flex.html.beads.layouts.NonVirtualBasicLayout');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.core.ILayoutChild');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout =
    function() {
  this.strand_ = null;
  this.className = 'NonVirtualBasicLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NonVirtualBasicLayout',
                qName: 'org.apache.flex.html.beads.layouts.NonVirtualBasicLayout'}],
      interfaces: [org.apache.flex.core.IBeadLayout] };


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.
    prototype.set_strand = function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    if (this.strand_.isWidthSizedToContent() &&
        this.strand_.isHeightSizedToContent())
      this.addOtherListeners();
    else {
      this.strand_.addEventListener('heightChanged',
          goog.bind(this.changeHandler, this));
      this.strand_.addEventListener('widthChanged',
          goog.bind(this.changeHandler, this));
      this.strand_.addEventListener('sizeChanged',
          goog.bind(this.sizeChangeHandler, this));
      if (!isNaN(this.strand_.get_explicitWidth()) &&
          !isNaN(this.strand_.get_explicitHeight()))
          this.addOtherListeners();
    }
  }
};


/**
 *
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.
    prototype.addOtherListeners = function() {
  this.strand_.addEventListener('childrenAdded',
      goog.bind(this.changeHandler, this));
  this.strand_.addEventListener('layoutNeeded',
     goog.bind(this.changeHandler, this));
  this.strand_.addEventListener('itemsCreated',
     goog.bind(this.changeHandler, this));
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.
    prototype.sizeChangeHandler = function(event) {
  this.addOtherListeners();
  this.changeHandler(event);
};


/**
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.
    prototype.changeHandler = function(event) {
  var i, n, h, w;

  var viewBead = this.strand_.getBeadByType(org.apache.flex.core.ILayoutParent);
  var contentView = viewBead.get_contentView();
  w = contentView.get_width();
  h = contentView.get_height();
  n = contentView.get_numElements();
  for (i = 0; i < n; i++) {
    var child = contentView.getElementAt(i);
    var left = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'left');
    var right = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'right');
    var top = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'top');
    var bottom = org.apache.flex.core.ValuesManager.valuesImpl.getValue(child, 'bottom');

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
