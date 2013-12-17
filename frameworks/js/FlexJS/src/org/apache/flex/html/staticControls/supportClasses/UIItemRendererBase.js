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

goog.provide('org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase');

goog.require('org.apache.flex.core.IItemRenderer');
goog.require('org.apache.flex.core.IItemRendererFactory');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.events.Event');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 * @implements {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase =
function() {
  this.renderers = new Array();
  goog.base(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIItemRendererBase',
                qName: 'org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase' }],
      interfaces: ['org.apache.flex.core.IItemRenderer, org.apache.flex.core.IItemRendererFactory']};


/**
 * @expose
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.addedToParent =
function() {
  goog.base(this, 'addedToParent');
};


/**
 * @expose
 * @return {Object} The data being used for the itemRenderer.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.get_data =
function() {
  return this.data_;
};


/**
 * @expose
 * @param {Object} value The data to use for the itemRenderer.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.set_data =
function(value) {
  this.data_ = value;
};


/**
 * @expose
 * @return {String} The name of the field being used to display the label.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.get_labelField =
function() {
  return this.labelField_;
};


/**
 * @expose
 * @param {String} value The name of the field to use for the label.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.set_labelField =
function(value) {
  this.labelField_ = value;
};


/**
 * @expose
 * @return {Number} The index value set for this itemRenderer.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.get_index =
function() {
  return this.index_;
};


/**
 * @expose
 * @param {Number} value The row index for this itemRenderer.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.set_index =
function(value) {
  this.index_ = value;
};


/**
 * @expose
 * @return {Boolean} The current value of the hovered state.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.get_hovered =
function() {
  return this.hovered_;
};


/**
 * @expose
 * @param {Boolean} value Set to true if the itemRenderer should go into hovered state.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.set_hovered =
function(value) {
  this.hovered_ = value;
};


/**
 * @expose
 * @return {Boolean} Whether or not the itemRenderer is selected.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.get_selected =
function() {
  return this.selected_;
};


/**
 * @expose
 * @param {Boolean} value True if this itemRenderer instance is selected.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.set_selected =
function(value) {
  this.selected_ = value;
};


/**
 * @expose
 * @return {Boolean} The value of the down selection.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.get_down =
function() {
  return this.down_;
};


/**
 * @expose
 * @param {Boolean} value True if the mouse is in the down position.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.set_down =
function(value) {
  this.down_ = value;
};


/**
 * @expose
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.updateRenderer =
function() {
  if (this.get_down()) {
  }
  else if (this.get_hovered()) {
  }
  else if (this.get_selected()) {
  }
};


/**
 * @expose
 * @param {Event} value The event that triggered the size change.
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.sizeChangeHandler =
function(value) {
  //this.adjustSize();
};


/**
 * @expose
 */
org.apache.flex.html.staticControls.supportClasses.UIItemRendererBase.prototype.adjustSize =
function() {
  // handle in sub-class
};
