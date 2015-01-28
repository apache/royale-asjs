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

goog.provide('org_apache_flex_html_supportClasses_UIItemRendererBase');

goog.require('org_apache_flex_core_IItemRenderer');
goog.require('org_apache_flex_core_IItemRendererFactory');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_events_Event');
goog.require('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 * @implements {org_apache_flex_core_IItemRenderer}
 */
org_apache_flex_html_supportClasses_UIItemRendererBase =
function() {
  org_apache_flex_html_supportClasses_UIItemRendererBase.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_supportClasses_UIItemRendererBase,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIItemRendererBase',
                qName: 'org_apache_flex_html_supportClasses_UIItemRendererBase' }],
      interfaces: [org_apache_flex_core_IItemRenderer, org_apache_flex_core_IItemRendererFactory]};


/**
 * @expose
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.addedToParent =
function() {
  org_apache_flex_html_supportClasses_UIItemRendererBase.base(this, 'addedToParent');

  // very common for item renderers to be resized by their containers,
  this.addEventListener('widthChanged', goog.bind(this.sizeChangeHandler, this));
  this.addEventListener('heightChanged', goog.bind(this.sizeChangeHandler, this));

  // each MXML file can also have styles in fx:Style block
  //? appropriate for JavaScript? ValuesManager.valuesImpl.init(this);

  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLInstances(this, this, this.get_MXMLDescriptor());

  this.dispatchEvent(new org_apache_flex_events_Event('initComplete'));
};


/**
 * @expose
 * @param {Array} data The data for the attributes.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.generateMXMLAttributes = function(data) {
  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties(this, data);
};


/**
 * @expose
 * @return {Object} The data being used for the itemRenderer.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.get_data =
function() {
  return this.data_;
};


/**
 * @expose
 * @param {Object} value The data to use for the itemRenderer.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.set_data =
function(value) {
  this.data_ = value;
};


/**
 * @expose
 * @return {String} The name of the field being used to display the label.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.get_labelField =
function() {
  return this.labelField_;
};


/**
 * @expose
 * @param {String} value The name of the field to use for the label.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.set_labelField =
function(value) {
  this.labelField_ = value;
};


/**
 * @expose
 * @return {Number} The index value set for this itemRenderer.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.get_index =
function() {
  return this.index_;
};


/**
 * @expose
 * @param {Number} value The row index for this itemRenderer.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.set_index =
function(value) {
  this.index_ = value;
};


/**
 * @expose
 * @return {Boolean} The current value of the hovered state.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.get_hovered =
function() {
  return this.hovered_;
};


/**
 * @expose
 * @param {Boolean} value Set to true if the itemRenderer should go into hovered state.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.set_hovered =
function(value) {
  this.hovered_ = value;
};


/**
 * @expose
 * @return {Boolean} Whether or not the itemRenderer is selected.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.get_selected =
function() {
  return this.selected_;
};


/**
 * @expose
 * @param {Boolean} value True if this itemRenderer instance is selected.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.set_selected =
function(value) {
  this.selected_ = value;
};


/**
 * @expose
 * @return {Boolean} The value of the down selection.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.get_down =
function() {
  return this.down_;
};


/**
 * @expose
 * @param {Boolean} value True if the mouse is in the down position.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.set_down =
function(value) {
  this.down_ = value;
};


/**
 * @expose
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.updateRenderer =
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
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.sizeChangeHandler =
function(value) {
  //this.adjustSize();
};


/**
 * @expose
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.adjustSize =
function() {
  // handle in sub-class
};
