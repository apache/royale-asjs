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

goog.provide('org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController');

goog.require('org_apache_flex_core_IBeadController');
goog.require('org_apache_flex_html_beads_ListView');
goog.require('org_apache_flex_html_beads_models_ArraySelectionModel');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadController}
 */
org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListSingleSelectionMouseController',
                qName: 'org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController' }],
      interfaces: [org_apache_flex_core_IBeadController] };


Object.defineProperties(org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController} */
        set: function(value) {
            this.strand_ = value;

            this.model = value.getBeadByType(
                org_apache_flex_html_beads_models_ArraySelectionModel);
            this.listView = value.getBeadByType(
                org_apache_flex_html_beads_ListView);

            this.dataGroup = this.listView.dataGroup;
            this.dataGroup.addEventListener('selected',
                goog.bind(this.selectedHandler, this));
        }
    }
});


/**
 * @expose
 *        ListSingleSelectionMouseController}
 * @param {Object} event The event that triggered the selection.
 */
org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController.prototype.selectedHandler =
        function(event) {

  var index = event.target.index;
  this.model.selectedIndex = index;

  var newEvent = new org_apache_flex_events_Event('change');
  this.strand_.dispatchEvent(newEvent);
};
