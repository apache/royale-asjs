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

goog.provide('org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer');

goog.require('org.apache.flex.html.beads.controllers.ItemRendererMouseController');
goog.require('org.apache.flex.html.supportClasses.DataItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.DataItemRenderer}
 */
org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer =
    function() {
  org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.
        supportClasses.ButtonBarButtonItemRenderer,
    org.apache.flex.html.supportClasses.DataItemRenderer);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBarButtonItemRenderer',
                qName: 'org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer' }] };


/**
 * @override
 */
org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.
    prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.button = document.createElement('button');
  this.element.appendChild(this.button);

  this.element.flexjs_wrapper = this;
  this.set_className('ButtonBarButtonItemRenderer');

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
 * @param {Object} value The strand.
 */
org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.
    prototype.set_strand = function(value) {

  this.strand_ = value;
};


/**
 * @expose
 * @return {Object} The strand.
 */
org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.
    prototype.get_strand = function() {
  return this.strand_;
};


/**
 * @expose
 * @param {Object} value The text to display.
 */
org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.
    prototype.set_data = function(value) {

  org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.base(this, 'set_data', value);

  if (value.hasOwnProperty('label')) {
    this.button.innerHTML = value.label;
  }
  else if (value.hasOwnProperty('title')) {
    this.button.innerHTML = value.title;
  }
  else {
    this.button.innerHHTML = String(value);
  }
};
