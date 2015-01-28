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

goog.provide('org_apache_flex_html_beads_models_DataGridModel');

goog.require('org_apache_flex_core_IDataGridModel');
goog.require('org_apache_flex_html_beads_models_ArraySelectionModel');



/**
 * @constructor
 * @extends {org_apache_flex_html_beads_models_ArraySelectionModel}
 * @implements {org_apache_flex_core_IDataGridModel}
 */
org_apache_flex_html_beads_models_DataGridModel =
    function() {
  org_apache_flex_html_beads_models_DataGridModel.base(this, 'constructor');

  this.labelFields_ = [];

  this.className = 'DataGridModel';
};
goog.inherits(
    org_apache_flex_html_beads_models_DataGridModel,
    org_apache_flex_html_beads_models_ArraySelectionModel);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_models_DataGridModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataGridModel',
                qName: 'org_apache_flex_html_beads_models_DataGridModel' }],
      interfaces: [org_apache_flex_core_IDataGridModel] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org_apache_flex_html_beads_models_DataGridModel.prototype.
    set_strand = function(value) {
  org_apache_flex_html_beads_models_DataGridModel.base(this, 'set_strand', value);
  this.strand_ = value;
};


/**
 * @expose
 * @param {Array} value Array of DataGridColumn instances.
 */
org_apache_flex_html_beads_models_DataGridModel.prototype.
    set_columns = function(value) {
  this.columns_ = value;
};


/**
 * @expose
 * @return {Array} Array of DataGridColumn instances.
 */
org_apache_flex_html_beads_models_DataGridModel.prototype.
    get_columns = function() {
  return this.columns_;
};
