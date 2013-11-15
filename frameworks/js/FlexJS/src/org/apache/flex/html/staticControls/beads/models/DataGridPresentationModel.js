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

goog.provide('org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel');

goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel =
    function() {
  goog.base(this);

  this.className = 'DataGridPresentationModel';
};
goog.inherits(
    org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataGridPresentationModel',
                qName: 'org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel'}] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel.
    prototype.set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @expose
 * @return {Object} value The array of column labels.
 */
org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel.
    prototype.get_columnLabels = function() {
  return this.columnLabels_;
};


/**
 * @expose
 * @param {Object} value The column labels.
 */
org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel.
    prototype.set_columnLabels = function(value) {
  this.columnLabels_ = value;
  this.dispatchEvent('columnLabelsChanged');
};


/**
 * @expose
 * @return {Object} value The height of every row.
 */
org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel.
    prototype.get_rowHeight = function() {
  return this.rowHeight_;
};


/**
 * @expose
 * @param {Object} value The height of every row.
 */
org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel.
    prototype.set_rowHeight = function(value) {
  this.rowHeight_ = value;
  this.dispatchEvent('rowHeightChanged');
};
