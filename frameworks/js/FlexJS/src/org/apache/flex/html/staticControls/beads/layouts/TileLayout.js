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

goog.provide('org.apache.flex.html.staticControls.beads.layouts.TileLayout');

goog.require('org.apache.flex.core.IBeadLayout');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout =
    function() {
  this.strand_ = null;
  this.className = 'TileLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TileLayout',
                qName: 'org.apache.flex.html.staticControls.beads.layouts.TileLayout'}],
      interfaces: [org.apache.flex.core.IBeadLayout] };


/**
 * @expose
 * @return {number} The number of columns wide for the layout.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.
  get_numColumns = function() {
  return this._numColumns;
};


/**
 * @expose
 * @param {number} value The number of columns wide for the layout.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.
  set_numColumns = function(value) {
  this._numColumns = value;
};


/**
 * @expose
 * @return {number} The width of each column in the layout.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.
  get_columnWidth = function() {
  return this._columnWidth;
};


/**
 * @expose
 * @param {number} value The width of each column in the layout.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.
  set_columnWidth = function(value) {
  this._columnWidth = value;
};


/**
 * @expose
 * @return {number} The height of each row of the layout.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.
  get_rowHeight = function() {
  return this._rowHeight;
};


/**
 * @expose
 * @param {number} value The height of each row of the Tile layout.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.
  set_rowHeight = function(value) {
  this._rowHeight = value;
};


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.prototype.
  set_strand = function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('childrenAdded',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('layoutNeeded',
        goog.bind(this.changeHandler, this));
  }
};


/**
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.staticControls.beads.layouts.TileLayout.
    prototype.changeHandler = function(event) {
  var children, i, n;
  var xpos, ypos, useWidth, useHeight;

  children = this.strand_.internalChildren();
  n = children.length;
  if (n === 0) return;

  xpos = 0;
  ypos = 0;
  useWidth = this.get_columnWidth();
  useHeight = this.get_rowHeight();

  if (isNaN(useWidth)) useWidth = Math.floor(this.strand_.get_width() / this.get_numColumns()); // + gap
  if (isNaN(useHeight)) {
    // given the width and total number of items, how many rows?
    var numRows = Math.floor(n / this.get_numColumns());
    useHeight = Math.floor(this.strand_.get_height() / numRows);
  }

  for (i = 0; i < n; i++)
  {
    var child = children[i].flexjs_wrapper;
    child.set_width(useWidth);
    child.set_height(useHeight);
    child.set_x(xpos);
    child.set_y(ypos);

    xpos += useWidth;

    if (((i + 1) % this.get_numColumns()) === 0) {
      xpos = 0;
      ypos += useHeight;
    }
  }
};
