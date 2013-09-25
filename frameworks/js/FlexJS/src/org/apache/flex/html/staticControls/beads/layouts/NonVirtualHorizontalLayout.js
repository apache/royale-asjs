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

goog.provide('org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout');

goog.require('org.apache.flex.html.staticControls.beads.ListView');

/**
 * @constructor
 */
org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout =
    function() {

  /**
   * @private
   * @type {Object}
   */
  this.strand_ = null;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.layouts.
          NonVirtualHorizontalLayout}
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout.
prototype.set_strand =
    function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('childrenAdded',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('itemsCreated',
        goog.bind(this.changeHandler, this));
    this.strand_.element.style.display = 'block';
  }
};


/**
 * @this {org.apache.flex.html.staticControls.beads.layouts.
          NonVirtualHorizontalLayout}
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout.
prototype.changeHandler = function(event) {
  var children, i, n;

  var layoutParent = this.strand_.getBeadByType(
      org.apache.flex.html.staticControls.beads.ListView);
  var contentView = layoutParent.get_dataGroup();

  children = contentView.internalChildren();
  n = children.length;
  for (i = 0; i < n; i++)
  {
    if (children[i].style.display == 'none')
      children[i].lastDisplay_ = 'inline-block';
    else
      children[i].style.display = 'inline-block';
  }
};


