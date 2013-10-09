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

goog.provide('org.apache.flex.html.staticControls.ComboBox');

goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.staticControls.beads.ComboBoxView');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.staticControls.ComboBox = function() {
  
  this.model = new
        org.apache.flex.html.staticControls.beads.models.ArraySelectionModel();
  this.addBead(this.model);
  
  goog.base(this);
  
};
goog.inherits(org.apache.flex.html.staticControls.ComboBox,
    org.apache.flex.core.ListBase);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.ComboBox}
 */
org.apache.flex.html.staticControls.ComboBox.prototype.createElement =
    function() {
  goog.base(this,'createElement');
  
  this.set_className('ComboBox');
  
  this.viewBead = new org.apache.flex.html.staticControls.beads.ComboBoxView();
  this.addBead(this.viewBead);
};


/**
 * @override
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {Array.<Object>} value The collection of data.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.set_dataProvider =
    function(value) {
  this.dataProvider = value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @return {string} The text getter.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.get_text = function() {
  return this.element.childNodes.item(0).value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {string} value The text setter.
 */
org.apache.flex.html.staticControls.ComboBox.prototype.set_text =
    function(value) {
  this.element.childNodes.item(0).value = value;
};
