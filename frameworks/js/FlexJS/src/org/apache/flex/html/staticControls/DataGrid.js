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

goog.provide('org.apache.flex.html.staticControls.DataGrid');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.staticControls.beads.models.DataGridModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.DataGrid = function() {

  //  this.model = new
  //        org.apache.flex.html.staticControls.beads.models.DataGridModel();
  //  this.addBead(this.model);

  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.DataGrid,
    org.apache.flex.core.UIBase);


/**
 * @override
 */
org.apache.flex.html.staticControls.DataGrid.prototype.createElement =
    function() {
  this.element = document.createElement('div');
  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
  this.set_className('DataGrid');

  // this.addBead(new
  //       org.apache.flex.html.staticControls.beads.DataGridView());
};


/**
 * @expose
 * @return {string} The dataProvider getter.
 */
org.apache.flex.html.staticControls.DataGrid.prototype.get_dataProvider =
    function() {
  return this.get_model().get_dataProvider();
};


/**
 * @expose
 * @param {string} value The dataProvider setter.
 */
org.apache.flex.html.staticControls.DataGrid.prototype.set_dataProvider =
    function(value) {
  this.get_model().set_dataProvider(value);
};


/**
 * @expose
 * @return {string} The labelFields getter.
 */
org.apache.flex.html.staticControls.DataGrid.prototype.get_labelFields =
    function() {
  return this.get_model().get_labelFields();
};


/**
 * @expose
 * @param {string} value The labelFields setter.
 */
org.apache.flex.html.staticControls.DataGrid.prototype.set_labelFields =
    function(value) {
  this.get_model().set_labelFields(value);
};


/**
 * @expose
 * @return {string} value The current selectedIndex.
 */
org.apache.flex.html.staticControls.DataGrid.prototype.get_selectedIndex =
    function() {
  return this.get_model().get_selectedIndex();
};
