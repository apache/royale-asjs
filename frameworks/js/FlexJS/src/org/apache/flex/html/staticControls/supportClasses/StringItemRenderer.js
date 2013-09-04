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

goog.provide('org.apache.flex.html.staticControls.supportClasses.StringItemRenderer');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.staticControls.beads.controllers.ItemRendererMouseController');

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.supportClasses.StringItemRenderer,
    org.apache.flex.core.UIBase);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.Label}
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.element.flexjs_wrapper = this;
  this.set_className('StringItemRenderer');
  
  // itemRenderers should provide something for the background to handle
  // the selection and highlight 
  this.backgroundView = this.element;
  
  this.controller = new org.apache.flex.html.staticControls.beads.controllers.ItemRendererMouseController();
  this.controller.set_strand(this);
};

org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
prototype.set_strand = function(value) {

  this.strand_ = value;
};

org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
prototype.get_strand = function() {
  return this.strand_;
};

org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
prototype.set_text = function(value) {

  this.element.innerHTML = value;
};

org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
prototype.get_text = function() {

  return this.element.innerHTML;
};

org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
prototype.set_selected = function(value) {
  this.selected_ = value;

  if (value) {
     this.backgroundView.style.backgroundColor = '#ACACAC';
   } else {
     this.backgroundView.style.backgroundColor = null;
   }
};

org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
prototype.set_hovered = function(value) {
  this.hovered_ = value;

  if (value) {
     this.backgroundView.style.backgroundColor='#999999';
   } else {
     if (this.selected_) {
       this.backgroundView.style.backgroundColor = '#ACACAC';
     } else {
       this.backgroundView.style.backgroundColor = null;
     }
   }
};


