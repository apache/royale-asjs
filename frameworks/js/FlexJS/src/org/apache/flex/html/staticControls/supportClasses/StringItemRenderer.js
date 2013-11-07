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
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer =
    function() {
  goog.base(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.supportClasses.StringItemRenderer,
    org.apache.flex.core.UIBase);


/**
 * @override
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

  this.controller = new org.apache.flex.html.staticControls.beads.controllers.
      ItemRendererMouseController();
  this.controller.set_strand(this);
};


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.set_strand = function(value) {

  this.strand_ = value;
};


/**
 * @expose
 * @return {Object} The strand.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.get_strand = function() {
  return this.strand_;
};


/**
 * @expose
 * @return {Object} The item renderer's parent.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.get_itemRendererParent = function() {
  return this.rendererParent_;
};


/**
 * @expose
 * @param {Object} value The item renderer's parent.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.set_itemRendererParent = function(value) {
  this.rendererParent_ = value;
};


/**
 * @expose
 * @return {Object} The renderer's index.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.get_index = function() {
  return this.index_;
};


/**
 * @expose
 * @param {Object} value The renderer's index.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.set_index = function(value) {
  this.index_ = value;
};


/**
 * @expose
 * @param {Object} value The text to display.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.set_text = function(value) {

  this.element.innerHTML = value;
};


/**
 * @expose
 * @return {Object} The text being displayed.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
    prototype.get_text = function() {

  return this.element.innerHTML;
};


/**
 * @expose
 * @param {boolean} value The selection state.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
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
 * @param {boolean} value The hovered state.
 */
org.apache.flex.html.staticControls.supportClasses.StringItemRenderer.
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
