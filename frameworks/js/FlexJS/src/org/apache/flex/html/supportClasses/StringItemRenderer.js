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

goog.provide('org_apache_flex_html_supportClasses_StringItemRenderer');

goog.require('org_apache_flex_core_IItemRenderer');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_beads_controllers_ItemRendererMouseController');
goog.require('org_apache_flex_html_supportClasses_DataItemRenderer');



/**
 * @constructor
 * @extends {org_apache_flex_html_supportClasses_DataItemRenderer}
 * @implements {org_apache_flex_core_IItemRenderer}
 */
org_apache_flex_html_supportClasses_StringItemRenderer =
    function() {
  org_apache_flex_html_supportClasses_StringItemRenderer.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_supportClasses_StringItemRenderer,
    org_apache_flex_html_supportClasses_DataItemRenderer);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'StringItemRenderer',
                qName: 'org_apache_flex_html_supportClasses_StringItemRenderer' }],
      interfaces: [org_apache_flex_core_IItemRenderer] };


/**
 * @override
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.element.flexjs_wrapper = this;
  this.className = 'StringItemRenderer';

  // itemRenderers should provide something for the background to handle
  // the selection and highlight
  this.backgroundView = this.element;

  this.controller = new org_apache_flex_html_beads_controllers_ItemRendererMouseController();
  this.controller.strand = this;

  return this.element;
};


/**
 * @expose
 * @param {Object} value The strand.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.set_strand = function(value) {

  this.strand_ = value;
};


/**
 * @expose
 * @return {Object} The strand.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.get_strand = function() {
  return this.strand_;
};


/**
 * @expose
 * @return {Object} The item renderer's parent.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.get_itemRendererParent = function() {
  return this.rendererParent_;
};


/**
 * @expose
 * @param {Object} value The item renderer's parent.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.set_itemRendererParent = function(value) {
  this.rendererParent_ = value;
};


/**
 * @expose
 * @param {Object} value The renderer's index.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.set_index = function(value) {
  this.index_ = value;
};


/**
 * @expose
 * @param {Object} value The text to display.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.set_text = function(value) {

  this.element.innerHTML = value;
};


/**
 * @expose
 * @return {Object} The text being displayed.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.get_text = function() {

  return this.element.innerHTML;
};


/**
 * @expose
 * @param {Object} value The text to display.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.set_data = function(value) {

  org_apache_flex_html_supportClasses_StringItemRenderer.base(this, 'set_data', value);

  if (this.labelField) {
    this.element.innerHTML = String(value[this.labelField]);
  }
  else if (this.dataField) {
    this.element.innerHTML = String(value[this.dataField]);
  }
  else if (value.toString) {
    this.element.innerHTML = value.toString();
  } else {
    this.element.innerHTML = String(value);
  }
};


/**
 * @expose
 * @return {Object} The text being displayed.
 */
org_apache_flex_html_supportClasses_StringItemRenderer.
    prototype.get_data = function() {

  return this.element.innerHTML;
};
