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

goog.provide('org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer');

goog.require('org_apache_flex_html_beads_controllers_ItemRendererMouseController');
goog.require('org_apache_flex_html_supportClasses_DataItemRenderer');



/**
 * @constructor
 * @extends {org_apache_flex_html_supportClasses_DataItemRenderer}
 */
org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer =
    function() {
  org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer,
    org_apache_flex_html_supportClasses_DataItemRenderer);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBarButtonItemRenderer',
                qName: 'org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer' }] };


/**
 * @override
 */
org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer.
    prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.button = document.createElement('button');
  this.button.style.width = '100%';
  this.button.style.height = '100%';
  this.element.appendChild(this.button);

  this.element.flexjs_wrapper = this;
  this.className = 'ButtonBarButtonItemRenderer';

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
org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer.
    prototype.set_strand = function(value) {

  this.strand_ = value;
};


/**
 * @expose
 * @return {Object} The strand.
 */
org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer.
    prototype.get_strand = function() {
  return this.strand_;
};


/**
 * @expose
 * @param {Object} value The text to display.
 */
org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer.
    prototype.set_data = function(value) {

  org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer.base(this, 'set_data', value);

  if (value.hasOwnProperty('label')) {
    this.button.innerHTML = value.label;
  }
  else if (value.hasOwnProperty('title')) {
    this.button.innerHTML = value.title;
  }
  else {
    this.button.innerHTML = value;
  }
};
