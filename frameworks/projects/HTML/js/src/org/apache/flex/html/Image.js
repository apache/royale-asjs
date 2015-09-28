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

goog.provide('org.apache.flex.html.Image');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.beads.ImageView');
goog.require('org.apache.flex.html.beads.models.ImageModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.Image = function() {
  org.apache.flex.html.Image.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.Image,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.Image.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Image',
                qName: 'org.apache.flex.html.Image' }] };


/**
 * @override
 * @protected
 * @return {Object} The actual element to be parented.
 */
org.apache.flex.html.Image.prototype.createElement =
    function() {

  this.element = document.createElement('img');
  this.element.className = 'Image';
  this.typeNames = 'Image';

  this.positioner = this.element;
  this.positioner.style.position = 'relative';
  this.element.flexjs_wrapper = this;

  this.model = new
          org.apache.flex.html.beads.models.ImageModel();

  this.addBead(new
      org.apache.flex.html.beads.ImageView());

  return this.element;
};


Object.defineProperties(org.apache.flex.html.Image.prototype, {
    /** @export */
    source: {
        /** @this {org.apache.flex.html.Image} */
        get: function() {
            return this.model.source;
        },
        /** @this {org.apache.flex.html.Image} */
        set: function(value) {
            this.model.source = value;
        }
    }
});
