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

goog.provide('org.apache.flex.html.staticControls.beads.ImageView');


goog.require('org.apache.flex.html.staticControls.beads.models.ImageModel');


/**
 * @constructor
 */
org.apache.flex.html.staticControls.beads.ImageView = function() {
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.ImageView}
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.ImageView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  this.model = value.getBeadByType(
        org.apache.flex.html.staticControls.beads.models.ImageModel);
  this.model.addEventListener('sourceChanged',
    goog.bind(this.sourceChangeHandler, this));
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.ImageView}
 * @param {Object} event The event triggered by the source change.
 */
org.apache.flex.html.staticControls.beads.ImageView.prototype.
sourceChangeHandler = function(event) {
  this.strand_.element.src = this.model.get_source();
};
