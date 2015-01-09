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

goog.provide('org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout');

goog.require('org.apache.flex.core.IBeadLayout');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout =
    function() {
  this.strand_ = null;
  this.className = 'NonVirtualHorizontalLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NonVirtualHorizontalLayout',
                qName: 'org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout' }],
      interfaces: [org.apache.flex.core.IBeadLayout] };


/**
 * @expose
          NonVirtualHorizontalLayout}
 * @param {Object} value The new host.
 */
org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout.
    prototype.set_strand =
    function(value) {
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
    this.strand_.element.style.display = 'block';
  }
};


/**
 *
 */
org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout.
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
org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout.
    prototype.sizeChangeHandler = function(event) {
  this.addOtherListeners();
  this.changeHandler(event);
};


/**
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.beads.layouts.NonVirtualHorizontalLayout.
    prototype.changeHandler = function(event) {
  var children, i, n;

  children = this.strand_.internalChildren();
  n = children.length;
  for (i = 0; i < n; i++)
  {
    var child = children[i];
    if (child.style.display == 'none')
      child.lastDisplay_ = 'inline-block';
    else
      child.style.display = 'inline-block';
    child.style.verticalAlign = 'middle';
    child.flexjs_wrapper.dispatchEvent('sizeChanged');
  }
};
