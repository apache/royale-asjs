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

goog.provide('org_apache_flex_html_beads_models_ListPresentationModel');

goog.require('org_apache_flex_core_IListPresentationModel');
goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @implements {org_apache_flex_core_IListPresentationModel}
 */
org_apache_flex_html_beads_models_ListPresentationModel =
    function() {
  org_apache_flex_html_beads_models_ListPresentationModel.base(this, 'constructor');
  this.className = 'ListPresentationModel';
};
goog.inherits(
    org_apache_flex_html_beads_models_ListPresentationModel,
    org_apache_flex_events_EventDispatcher);


/**
 * @private
 * @type {number}
 */
org_apache_flex_html_beads_models_ListPresentationModel.prototype.rowHeight_ = 30;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_models_ListPresentationModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListPresentationModel',
                qName: 'org_apache_flex_html_beads_models_ListPresentationModel' }],
      interfaces: [org_apache_flex_core_IListPresentationModel] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org_apache_flex_html_beads_models_ListPresentationModel.prototype.
    set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @expose
 * @return {number} value The height of the rows.
 */
org_apache_flex_html_beads_models_ListPresentationModel.prototype.
    get_rowHeight = function() {
  return this.rowHeight_;
};


/**
 * @expose
 * @param {number} value The height of the rows.
 */
org_apache_flex_html_beads_models_ListPresentationModel.prototype.
    set_rowHeight = function(value) {
  this.rowHeight_ = value;
  this.dispatchEvent('rowHeightChanged');
};
