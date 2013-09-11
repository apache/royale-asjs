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

goog.provide('org.apache.flex.html.staticControls.Image');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.staticControls.beads.ImageView');
goog.require('org.apache.flex.html.staticControls.beads.models.ImageModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.Image = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.Image,
    org.apache.flex.core.UIBase);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.Container}
 */
org.apache.flex.html.staticControls.Image.prototype.createElement =
    function(p) {

  this.element = document.createElement('img');

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  this.model = new
          org.apache.flex.html.staticControls.beads.models.ImageModel();

  this.addBead(this.model);

  this.addBead(new
         org.apache.flex.html.staticControls.beads.ImageView());
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Image}
 * @return {String} The source identifier for the Image.
 */
org.apache.flex.html.staticControls.Image.prototype.
get_source = function() {
  return this.model.get_source();
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Image}
 * @param {String} value The source identifier for the Image.
 */
org.apache.flex.html.staticControls.Image.prototype.
set_source = function(value) {
   this.model.set_source(value);
};
