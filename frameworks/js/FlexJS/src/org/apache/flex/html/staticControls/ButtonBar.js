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

goog.provide('org.apache.flex.html.staticControls.ButtonBar');

goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.html.staticControls.List');
goog.require('org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout');
goog.require('org.apache.flex.html.staticControls.supportClasses.ButtonBarButtonItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.List}
 */
org.apache.flex.html.staticControls.ButtonBar = function() {

  //  this.model = new
  //        org.apache.flex.html.staticControls.beads.models.ArraySelectionModel();
  //  this.addBead(this.model);

  goog.base(this);

  //  this.addBead(new
  //        org.apache.flex.html.staticControls.beads.ListView());

  //  this.addBead(new
  //org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout());

  //  this.itemRendererFactory = new
  //        org.apache.flex.html.staticControls.beads.
  //        DataItemRendererFactoryForArrayData();
  //  this.itemRendererFactory.set_itemRendererClass('org.apache.flex.html.' +
  //        'staticControls.supportClasses.ButtonBarButtonItemRenderer');
  //  this.addBead(this.itemRendererFactory);

  //  this.addBead(new
  //        org.apache.flex.html.staticControls.beads.controllers.
  //        ListSingleSelectionMouseController());
};
goog.inherits(org.apache.flex.html.staticControls.ButtonBar,
    org.apache.flex.html.staticControls.List);


/**
 * @override
 */
org.apache.flex.html.staticControls.ButtonBar.prototype.createElement =
    function() {
  //goog.base(this, 'createElement');

  this.element = document.createElement('div');
  this.element.style.overflow = 'auto';
  this.element.style.border = 'solid';
  this.element.style.borderWidth = '1px';
  this.element.style.borderColor = '#333333';
  this.positioner = this.element;

  this.set_className('ButtonBar');

  return this.element;
};
