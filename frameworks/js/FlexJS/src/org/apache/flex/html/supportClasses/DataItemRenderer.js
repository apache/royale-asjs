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

goog.provide('org.apache.flex.html.supportClasses.DataItemRenderer');

goog.require('org.apache.flex.core.IItemRenderer');
goog.require('org.apache.flex.html.beads.controllers.ItemRendererMouseController');
goog.require('org.apache.flex.html.supportClasses.UIItemRendererBase');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.UIItemRendererBase}
 * @implements {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.html.supportClasses.DataItemRenderer =
    function() {
  org.apache.flex.html.supportClasses.DataItemRenderer.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.supportClasses.DataItemRenderer,
    org.apache.flex.html.supportClasses.UIItemRendererBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataItemRenderer',
                qName: 'org.apache.flex.html.supportClasses.DataItemRenderer' }],
      interfaces: [org.apache.flex.core.IItemRenderer] };


/**
 * @override
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.element.flexjs_wrapper = this;
  this.set_className('DataItemRenderer');

  // itemRenderers should provide something for the background to handle
  // the selection and highlight
  this.backgroundView = this.element;

  this.controller = new org.apache.flex.html.beads.controllers.
      ItemRendererMouseController();
  this.controller.set_strand(this);

  return this.element;
};


/**
 * @expose
 * @return {Object} The item renderer's parent.
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.get_itemRendererParent = function() {
  return this.rendererParent_;
};


/**
 * @expose
 * @param {Object} value The item renderer's parent.
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.set_itemRendererParent = function(value) {
  this.rendererParent_ = value;
};


/**
 * @expose
 * @param {Object} value The renderer's index.
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.set_index = function(value) {
  this.index_ = value;
};


/**
 * @expose
 * @param {string} value The name of field to use.
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.set_dataField = function(value) {

  this.dataField_ = value;
};


/**
 * @expose
 * @return {string} The name of the field to use.
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.get_dataField = function() {

  return this.dataField_;
};


/**
 * @override
 * @param {Boolean} value The selection state.
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
    prototype.set_selected = function(value) {
  this.selected_ = value;

  if (value) {
    this.backgroundView.style.backgroundColor = '#9C9C9C';
  } else {
    this.backgroundView.style.backgroundColor = null;
  }
};


/**
 * @override
 * @param {Boolean} value The hovered state.
 */
org.apache.flex.html.supportClasses.DataItemRenderer.
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
