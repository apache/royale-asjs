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

goog.provide('org.apache.flex.html.beads.models.ImageModel');

goog.require('org.apache.flex.core.IBeadModel');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.html.beads.models.ImageModel =
    function() {
  org.apache.flex.html.beads.models.ImageModel.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.beads.models.ImageModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.models.ImageModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ImageModel',
                qName: 'org.apache.flex.html.beads.models.ImageModel'}],
      interfaces: [org.apache.flex.core.IBeadModel]};


Object.defineProperties(org.apache.flex.html.beads.models.ImageModel.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.models.ImageModel} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    /** @export */
    source: {
        /** @this {org.apache.flex.html.beads.models.ImageModel} */
        get: function() {
            return this.source_;
        },
        /** @this {org.apache.flex.html.beads.models.ImageModel} */
        set: function(value) {
            this.source_ = value;
            this.dispatchEvent('sourceChanged');
        }
    }
});
