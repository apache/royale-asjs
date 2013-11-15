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

goog.provide('org.apache.flex.html.staticControls.beads.models.ImageModel');

goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.html.staticControls.beads.models.ImageModel =
    function() {
  goog.base(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.beads.models.ImageModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.models.ImageModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ImageModel',
                qName: 'org.apache.flex.html.staticControls.beads.models.ImageModel'}] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.beads.models.ImageModel.prototype.
    set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @expose
 * @return {Object} value The image source.
 */
org.apache.flex.html.staticControls.beads.models.ImageModel.prototype.
    get_source = function() {
  return this.source;
};


/**
 * @expose
 * @param {Object} value The image source.
 */
org.apache.flex.html.staticControls.beads.models.ImageModel.prototype.
    set_source = function(value) {
  this.source = value;
  this.dispatchEvent('sourceChanged');
};
