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

goog.provide('org.apache.flex.html.staticControls.supportClasses.DataGridColumn');

goog.require('mx.core.IFactory');



/**
 * @constructor
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn =
    function() {
};


/**
 * @expose
 * @return {mx.core.IFactory} The object factory for the itemRenderer.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.get_itemRenderer =
function() {
  return this.itemRenderer_;
};


/**
 * @expose
 * @param {mx.core.IFactory} value The object factory for the itemRenderer.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.set_itemRenderer =
function(value) {
  this.itemRenderer_ = value;
};


/**
 * @expose
 * @return {Number} The width of the column.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.get_columnWidth =
function() {
  return this.columnWidth_;
};


/**
 * @expose
 * @param {Number} value The width of the column.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.set_columnWidth =
function(value) {
  this.columnWidth_ = value;
};


/**
 * @expose
 * @return {String} The label for the column.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.get_label =
function() {
  return this.label_;
};


/**
 * @expose
 * @param {String} value The label for the column.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.set_label =
function(value) {
  this.label_ = value;
};


/**
 * @expose
 * @return {String} The field for the data for the column.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.get_dataField =
function() {
  return this.dataField_;
};


/**
 * @expose
 * @param {String} value The field for the data for the column.
 */
org.apache.flex.html.staticControls.supportClasses.DataGridColumn.prototype.set_dataField =
function(value) {
  this.dataField_ = value;
};

