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

goog.provide('org.apache.flex.html.staticControls.supportClasses.DataItemRenderer');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.staticControls.beads.controllers.ItemRendererMouseController');

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer =
function() {
  goog.base(this);
};
goog.inherits(
  org.apache.flex.html.staticControls.supportClasses.DataItemRenderer,
  org.apache.flex.core.UIBase);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.element.flexjs_wrapper = this;
  this.set_className('DataItemRenderer');

  // itemRenderers should provide something for the background to handle
  // the selection and highlight
  this.backgroundView = this.element;

  this.controller = new org.apache.flex.html.staticControls.beads.controllers.
      ItemRendererMouseController();
  this.controller.set_strand(this);
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.set_strand = function(value) {

  this.strand_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @return {Object} The strand.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.get_strand = function() {
  return this.strand_;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @return {Object} The item renderer's parent.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.get_itemRendererParent = function() {
  return this.rendererParent_;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @param {Object} value The item renderer's parent.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.set_itemRendererParent = function(value) {
  this.rendererParent_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @return {Object} The renderer's index.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.get_index = function() {
  return this.index_;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @param {Object} value The renderer's index.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.set_index = function(value) {
  this.index_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @param {Object} value The data to display.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.set_data = function(value) {

  this.data = value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @return {Object} The value being displayed.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.get_data = function() {

  return this.data;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @param {boolean} value The selection state.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.set_selected = function(value) {
  this.selected_ = value;

  if (value) {
     this.backgroundView.style.backgroundColor = '#9C9C9C';
   } else {
     this.backgroundView.style.backgroundColor = null;
   }
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.supportClasses.DataItemRenderer}
 * @param {boolean} value The hovered state.
 */
org.apache.flex.html.staticControls.supportClasses.DataItemRenderer.
prototype.set_hovered = function(value) {
  this.hovered_ = value;

  if (value) {
     this.backgroundView.style.backgroundColor = '#ECECEC';
   } else {
     if (this.selected_) {
       this.backgroundView.style.backgroundColor = '#9C9C9C';
     } else {
       this.backgroundView.style.backgroundColor = null;
     }
   }
};
