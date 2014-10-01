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

goog.provide('org.apache.flex.html.beads.models.ListPresentationModel');

goog.require('org.apache.flex.core.IListPresentationModel');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.IListPresentationModel}
 */
org.apache.flex.html.beads.models.ListPresentationModel =
    function() {
  org.apache.flex.html.beads.models.ListPresentationModel.base(this, 'constructor');
  this.className = 'ListPresentationModel';
};
goog.inherits(
    org.apache.flex.html.beads.models.ListPresentationModel,
    org.apache.flex.events.EventDispatcher);


/**
 * @private
 * @type {number}
 */
org.apache.flex.html.beads.models.ListPresentationModel.prototype.rowHeight_ = 30;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.models.ListPresentationModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListPresentationModel',
                qName: 'org.apache.flex.html.beads.models.ListPresentationModel' }],
      interfaces: [org.apache.flex.core.IListPresentationModel] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.beads.models.ListPresentationModel.prototype.
    set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @expose
 * @return {number} value The height of the rows.
 */
org.apache.flex.html.beads.models.ListPresentationModel.prototype.
    get_rowHeight = function() {
  return this.rowHeight_;
};


/**
 * @expose
 * @param {number} value The height of the rows.
 */
org.apache.flex.html.beads.models.ListPresentationModel.prototype.
    set_rowHeight = function(value) {
  this.rowHeight_ = value;
  this.dispatchEvent('rowHeightChanged');
};
