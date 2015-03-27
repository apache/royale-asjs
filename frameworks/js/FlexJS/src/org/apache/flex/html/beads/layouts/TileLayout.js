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

goog.provide('org_apache_flex_html_beads_layouts_TileLayout');

goog.require('org_apache_flex_core_IBeadLayout');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadLayout}
 */
org_apache_flex_html_beads_layouts_TileLayout =
    function() {
  this.strand_ = null;
  this.className = 'TileLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_layouts_TileLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TileLayout',
                qName: 'org_apache_flex_html_beads_layouts_TileLayout'}],
      interfaces: [org_apache_flex_core_IBeadLayout] };


Object.defineProperties(org_apache_flex_html_beads_layouts_TileLayout.prototype, {
    'strand': {
        /** @this {org_apache_flex_html_beads_layouts_TileLayout} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
              this.strand_.addEventListener('childrenAdded',
                  goog.bind(this.changeHandler, this));
              this.strand_.addEventListener('layoutNeeded',
                  goog.bind(this.changeHandler, this));
            }
        }
    },
    'numColumns': {
        /** @this {org_apache_flex_html_beads_layouts_TileLayout} */
        get: function() {
            return this._numColumns;
        },
        /** @this {org_apache_flex_html_beads_layouts_TileLayout} */
        set: function(value) {
            this._numColumns = value;
        }
    },
    'columnWidth': {
        /** @this {org_apache_flex_html_beads_layouts_TileLayout} */
        get: function() {
            return this._columnWidth;
        },
        /** @this {org_apache_flex_html_beads_layouts_TileLayout} */
        set: function(value) {
            this._columnWidth = value;
        }
    },
    'rowHeight': {
        /** @this {org_apache_flex_html_beads_layouts_TileLayout} */
        get: function() {
            return this._rowHeight;
        },
        /** @this {org_apache_flex_html_beads_layouts_TileLayout} */
        set: function(value) {
            this._rowHeight = value;
        }
    }
});


/**
 * @param {org_apache_flex_events_Event} event The text getter.
 */
org_apache_flex_html_beads_layouts_TileLayout.
    prototype.changeHandler = function(event) {
  var children, i, n;
  var xpos, ypos, useWidth, useHeight;

  children = this.strand_.internalChildren();
  n = children.length;
  if (n === 0) return;

  xpos = 0;
  ypos = 0;
  useWidth = this.columnWidth;
  useHeight = this.rowHeight;

  if (isNaN(useWidth)) useWidth = Math.floor(this.strand_.width / this.numColumns); // + gap
  if (isNaN(useHeight)) {
    // given the width and total number of items, how many rows?
    var numRows = Math.floor(n / this.numColumns);
    useHeight = Math.floor(this.strand_.height / numRows);
  }

  for (i = 0; i < n; i++)
  {
    var child = children[i].flexjs_wrapper;
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
};
