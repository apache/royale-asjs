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

goog.provide('org.apache.flex.html.staticControls.beads.models.DataGridModel');

goog.require('org.apache.flex.core.IDataGridModel');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.beads.models.ArraySelectionModel}
 * @implements {org.apache.flex.core.IDataGridModel}
 */
org.apache.flex.html.staticControls.beads.models.DataGridModel =
    function() {
  goog.base(this);

  this.labelFields_ = [];

  this.className = 'DataGridModel';
};
goog.inherits(
    org.apache.flex.html.staticControls.beads.models.DataGridModel,
    org.apache.flex.html.staticControls.beads.models.ArraySelectionModel);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.models.DataGridModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataGridModel',
                qName: 'org.apache.flex.html.staticControls.beads.models.DataGridModel' }],
      interfaces: [org.apache.flex.core.IDataGridModel] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.beads.models.DataGridModel.prototype.
    set_strand = function(value) {
  goog.base(this, 'set_strand', value);
  this.strand_ = value;
};


/**
 * @expose
 * @param {Array} value Array of label fields.
 */
org.apache.flex.html.staticControls.beads.models.DataGridModel.prototype.
    set_labelFields = function(value) {
  this.labelFields_ = value;
};


/**
 * @expose
 * @return {Array} Array of label fields.
 */
org.apache.flex.html.staticControls.beads.models.DataGridModel.prototype.
    get_labelFields = function() {
  return this.labelFields_;
};


/**
 * @expose
 * @param {Array} value Array of DataGridColumn instances.
 */
org.apache.flex.html.staticControls.beads.models.DataGridModel.prototype.
    set_columns = function(value) {
  this.columns_ = value;
};


/**
 * @expose
 * @return {Array} Array of DataGridColumn instances.
 */
org.apache.flex.html.staticControls.beads.models.DataGridModel.prototype.
    get_columns = function() {
  return this.columns_;
};
