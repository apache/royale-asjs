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

goog.provide('org.apache.flex.html.beads.layouts.TileLayout');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.core.ILayoutParent');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.TileLayout =
    function() {
  this.strand_ = null;
  this.className = 'TileLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.TileLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TileLayout',
                qName: 'org.apache.flex.html.beads.layouts.TileLayout'}],
      interfaces: [org.apache.flex.core.IBeadLayout] };


Object.defineProperties(org.apache.flex.html.beads.layouts.TileLayout.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.layouts.TileLayout} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
            }
        }
    },
    /** @export */
    numColumns: {
        /** @this {org.apache.flex.html.beads.layouts.TileLayout} */
        get: function() {
            return this._numColumns;
        },
        /** @this {org.apache.flex.html.beads.layouts.TileLayout} */
        set: function(value) {
            this._numColumns = value;
        }
    },
    /** @export */
    columnWidth: {
        /** @this {org.apache.flex.html.beads.layouts.TileLayout} */
        get: function() {
            return this._columnWidth;
        },
        /** @this {org.apache.flex.html.beads.layouts.TileLayout} */
        set: function(value) {
            this._columnWidth = value;
        }
    },
    /** @export */
    rowHeight: {
        /** @this {org.apache.flex.html.beads.layouts.TileLayout} */
        get: function() {
            return this._rowHeight;
        },
        /** @this {org.apache.flex.html.beads.layouts.TileLayout} */
        set: function(value) {
            this._rowHeight = value;
        }
    }
});


/**
 */
org.apache.flex.html.beads.layouts.TileLayout.
    prototype.layout = function() {
  var children, i, n, child;
  var xpos, ypos, useWidth, useHeight;

  var viewBead = this.strand_.getBeadByType(org.apache.flex.core.ILayoutParent);
  var contentView = viewBead.contentView;
  children = contentView.internalChildren();
  n = children.length;
  if (n === 0) return;

  var realN = n;
  for (i = 0; i < n; i++)
  {
    child = children[i].flexjs_wrapper;
    if (!child.visible) realN--;
  }

  xpos = 0;
  ypos = 0;
  useWidth = this.columnWidth;
  useHeight = this.rowHeight;

  if (isNaN(useWidth)) useWidth = Math.floor(this.strand_.width / this.numColumns); // + gap
  if (isNaN(useHeight)) {
    // given the width and total number of items, how many rows?
    var numRows = Math.floor(realN / this.numColumns);
    useHeight = Math.floor(this.strand_.height / numRows);
  }

  for (i = 0; i < n; i++)
  {
    child = children[i].flexjs_wrapper;
    if (!child.visible) continue;
    child.positioner.internalDisplay = 'inline-block';
    child.width = useWidth;
    child.height = useHeight;
  }
/*
  var realN = n;
  for (i = 0; i < n; i++)
  {
    child = children[i].flexjs_wrapper;
    if (!child.get_visible()) realN--;
  }

  xpos = 0;
  ypos = 0;
  useWidth = this.columnWidth;
  useHeight = this.rowHeight;

  if (isNaN(useWidth)) useWidth = Math.floor(this.strand_.width / this.numColumns); // + gap
  if (isNaN(useHeight)) {
    // given the width and total number of items, how many rows?
    var numRows = Math.floor(realN / this.numColumns);
    useHeight = Math.floor(this.strand_.height / numRows);
  }

  for (i = 0; i < n; i++)
  {
    child = children[i].flexjs_wrapper;
    if (!child.visible) continue;
    child.positioner.internalDisplay = 'inline-block';
    child.width = useWidth;
    child.height = useHeight;
    child.x = xpos;
    child.y = ypos;

    xpos += useWidth;

    if (((i + 1) % this.numColumns) === 0) {
      xpos = 0;
      ypos += useHeight;
    }
  }
*/
};
