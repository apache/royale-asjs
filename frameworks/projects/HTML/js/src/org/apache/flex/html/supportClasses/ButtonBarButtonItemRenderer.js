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
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.DataItemRenderer}
 */
org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer =
    function() {
  org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer,
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
  this.positioner.style.position = 'relative';

  this.button = document.createElement('button');
  this.button.style.width = '100%';
  this.button.style.height = '100%';
  this.element.appendChild(this.button);

  this.element.flexjs_wrapper = this;
  this.className = 'ButtonBarButtonItemRenderer';

  // itemRenderers should provide something for the background to handle
  // the selection and highlight
  this.backgroundView = this.element;

  this.controller = new org.apache.flex.html.beads.controllers.ItemRendererMouseController();
  this.controller.strand = this;

  return this.element;
};


Object.defineProperties(org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer} */
        set: function(value) {
            this.strand_ = value;
        },
        /** @this {org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer} */
        get: function() {
            return this.strand_;
        }
    },
    /** @export */
    data: {
        /** @this {org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(
                org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer, this, 'data', value);

            if (value.hasOwnProperty('label')) {
              this.button.innerHTML = value.label;
            }
            else if (value.hasOwnProperty('title')) {
              this.button.innerHTML = value.title;
            }
            else {
              this.button.innerHTML = value;
            }
        }
    }
});
