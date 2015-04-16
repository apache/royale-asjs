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

goog.provide('org_apache_flex_html_ButtonBar');

goog.require('org_apache_flex_core_ListBase');
goog.require('org_apache_flex_html_List');
goog.require('org_apache_flex_html_beads_DataItemRendererFactoryForArrayData');
goog.require('org_apache_flex_html_beads_layouts_HorizontalLayout');
goog.require('org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer');



/**
 * @constructor
 * @extends {org_apache_flex_html_List}
 */
org_apache_flex_html_ButtonBar = function() {

  //  this.model = new
  //        org_apache_flex_html_beads_models_ArraySelectionModel();
  //  this.addBead(this.model);

  org_apache_flex_html_ButtonBar.base(this, 'constructor');

  //  this.addBead(new
  //        org_apache_flex_html_beads_ListView());

  //  this.addBead(new
  //org_apache_flex_html_beads_layouts_HorizontalLayout());

  //  this.itemRendererFactory = new
  //        org_apache_flex_html_beads_
  //        DataItemRendererFactoryForArrayData();
  //  this.itemRendererFactory.itemRendererClass = 'org_apache_flex_html_' +
  //        'supportClasses_ButtonBarButtonItemRenderer';
  //  this.addBead(this.itemRendererFactory);

  //  this.addBead(new
  //        org_apache_flex_html_beads_controllers_
  //        ListSingleSelectionMouseController());
};
goog.inherits(org_apache_flex_html_ButtonBar,
    org_apache_flex_html_List);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_ButtonBar.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBar',
                qName: 'org_apache_flex_html_ButtonBar'}] };


/**
 * @override
 */
org_apache_flex_html_ButtonBar.prototype.createElement =
    function() {
  //org_apache_flex_html_ButtonBar.base(this, 'createElement');

  this.element = document.createElement('div');
  this.element.style.overflow = 'auto';
  this.element.style.border = 'solid';
  this.element.style.borderWidth = '1px';
  this.element.style.borderColor = '#333333';
  this.positioner = this.element;

  this.className = 'ButtonBar';

  this.element.flexjs_wrapper = this;

  return this.element;
};
