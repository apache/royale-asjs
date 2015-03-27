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

goog.provide('org_apache_flex_html_Image');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_beads_ImageView');
goog.require('org_apache_flex_html_beads_models_ImageModel');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_Image = function() {
  org_apache_flex_html_Image.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_Image,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_Image.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Image',
                qName: 'org_apache_flex_html_Image' }] };


/**
 * @override
 * @protected
 * @return {Object} The actual element to be parented.
 */
org_apache_flex_html_Image.prototype.createElement =
    function() {

  this.element = document.createElement('img');

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  this.model = new
          org_apache_flex_html_beads_models_ImageModel();

  this.addBead(this.model);

  this.addBead(new
      org_apache_flex_html_beads_ImageView());

  return this.element;
};


Object.defineProperties(org_apache_flex_html_Image.prototype, {
    'source': {
        /** @this {org_apache_flex_html_Image} */
        get: function() {
            return this.model.source;
        },
        /** @this {org_apache_flex_html_Image} */
        set: function(value) {
            this.model.source = value;
        }
    }
});
