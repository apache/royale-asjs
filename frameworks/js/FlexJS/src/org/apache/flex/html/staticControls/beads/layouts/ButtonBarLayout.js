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

goog.provide('org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.html.staticControls.beads.ListView');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout =
    function() {
  this.strand_ = null;

  this.className = 'ButtonBarLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout
    .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBarLayout',
                qName: 'org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout' }],
      interfaces: [org.apache.flex.core.IBeadLayout] };


/**
 * @expose
 * @param {Array} value A set of widths to use for each button (optional).
 */
org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout.prototype.set_buttonWidths =
function(value) {
  this.buttonWidths_ = value;
};


/**
 * @expose
 * @return {Array} A set of widths to use for each button.
 */
org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout.prototype.get_buttonWidths =
function() {
  return this.buttonWidths_;
};


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout.
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
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.staticControls.beads.layouts.ButtonBarLayout.
    prototype.changeHandler = function(event) {
  var children, i, n, xpos, useWidth, useHeight;

  children = this.strand_.internalChildren();
  n = children.length;

  xpos = 0;
  useWidth = this.strand_.get_width() / n;
  useHeight = this.strand_.get_height();

  for (i = 0; i < n; i++)
  {
    children[i].set_height(useHeight);
    if (this.buttonWidths_) children[i].set_width(this.buttonWidths_[i]);
    else children[i].set_width(useWidth);
    children[i].element.style['vertical-align'] = 'middle';
    children[i].element.style['text-align'] = 'center';
    children[i].element.style['left-margin'] = 'auto';
    children[i].element.style['right-margin'] = 'auto';

    if (children[i].element.style.display == 'none')
      children[i].lastDisplay_ = 'inline-block';
    else
      children[i].element.style.display = 'inline-block';
  }
};
