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

goog.provide('org.apache.flex.html.beads.ImageView');


goog.require('org.apache.flex.html.beads.models.ImageModel');



/**
 * @constructor
 */
org.apache.flex.html.beads.ImageView = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.ImageView
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ImageView',
                qName: 'org.apache.flex.html.beads.ImageView'}] };


Object.defineProperties(org.apache.flex.html.beads.ImageView.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.ImageView} */
        set: function(value) {
            this.strand_ = value;

            this.model = value.getBeadByType(
                org.apache.flex.html.beads.models.ImageModel);
            this.model.addEventListener('sourceChanged',
                goog.bind(this.sourceChangeHandler, this));
        }
    }
});


/**
 * @export
 * @param {Object} event The event triggered by the source change.
 */
org.apache.flex.html.beads.ImageView.prototype.
    sourceChangeHandler = function(event) {
  this.strand_.element.src = this.model.source;
  this.strand_.element.addEventListener('load',
      goog.bind(this.loadHandler, this));
};


/**
 * @export
 * @param {Object} event The event triggered by the source change.
 */
org.apache.flex.html.beads.ImageView.prototype.
    loadHandler = function(event) {
  this.strand_.parent.dispatchEvent('layoutNeeded');
};
