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

goog.provide('org_apache_flex_html_beads_ImageView');


goog.require('org_apache_flex_html_beads_models_ImageModel');



/**
 * @constructor
 */
org_apache_flex_html_beads_ImageView = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_ImageView
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ImageView',
                qName: 'org_apache_flex_html_beads_ImageView'}] };


Object.defineProperties(org_apache_flex_html_beads_ImageView.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_ImageView} */
        set: function(value) {
            this.strand_ = value;

            this.model = value.getBeadByType(
                org_apache_flex_html_beads_models_ImageModel);
            this.model.addEventListener('sourceChanged',
                goog.bind(this.sourceChangeHandler, this));
        }
    }
});


/**
 * @expose
 * @param {Object} event The event triggered by the source change.
 */
org_apache_flex_html_beads_ImageView.prototype.
    sourceChangeHandler = function(event) {
  this.strand_.element.src = this.model.source;
};
