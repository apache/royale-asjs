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

goog.provide('org_apache_flex_html_beads_models_ImageModel');

goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_html_beads_models_ImageModel =
    function() {
  org_apache_flex_html_beads_models_ImageModel.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_beads_models_ImageModel,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_models_ImageModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ImageModel',
                qName: 'org_apache_flex_html_beads_models_ImageModel'}],
      interfaces: [ org_apache_flex_core_IBeadModel] };


Object.defineProperties(org_apache_flex_html_beads_models_ImageModel.prototype, {
    'strand': {
        /** @this {org_apache_flex_html_beads_models_ImageModel} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    'source': {
        /** @this {org_apache_flex_html_beads_models_ImageModel} */
        get: function() {
            return this.source_;
        },
        /** @this {org_apache_flex_html_beads_models_ImageModel} */
        set: function(value) {
            this.source_ = value;
            this.dispatchEvent('sourceChanged');
        }
    }
});
