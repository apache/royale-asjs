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

goog.provide('org.apache.flex.html.staticControls.beads.DataGridColumnView');

goog.require('org.apache.flex.html.staticControls.beads.ListView');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.beads.ListView}
 */
org.apache.flex.html.staticControls.beads.DataGridColumnView = function() {
  goog.base(this);
  this.className = 'DataGridColumnView';
};
goog.inherits(
    org.apache.flex.html.staticControls.beads.DataGridColumnView,
    org.apache.flex.html.staticControls.beads.ListView);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.DataGridColumnView.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataGridColumnView',
                qName: 'org.apache.flex.html.staticControls.beads.DataGridColumnView' }],
      interfaces: [org.apache.flex.html.staticControls.beads.IListView,
                   org.apache.flex.core.IBeadView]};


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.DataGridColumnView.prototype.
    set_strand = function(value) {
  this.strand_ = value;

  goog.base(this, 'set_strand', value);
};


/**
 * @expose
 * @return {number} The column index for this grid column.
 */
org.apache.flex.html.staticControls.beads.DataGridColumnView.prototype.
    get_columnIndex = function() {
  return this.columnIndex_;
};


/**
 * @expose
 * @param {number} value The column index for this grid column.
 */
org.apache.flex.html.staticControls.beads.DataGridColumnView.prototype.
    set_columnIndex = function(value) {
  this.columnIndex_ = value;
};


/**
 * @expose
 * @return {string} The field in the data to use for the column's label.
 */
org.apache.flex.html.staticControls.beads.DataGridColumnView.prototype.
    get_labelField = function() {
  return this.labelField_;
};


/**
 * @expose
 * @param {string} value The field in the data to use for the column's label.
 */
org.apache.flex.html.staticControls.beads.DataGridColumnView.prototype.
    set_labelField = function(value) {
  this.labelField_ = value;
};
