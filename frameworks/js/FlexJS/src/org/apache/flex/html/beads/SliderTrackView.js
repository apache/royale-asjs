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

goog.provide('org_apache_flex_html_beads_SliderTrackView');



/**
 * @constructor
 */
org_apache_flex_html_beads_SliderTrackView = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_SliderTrackView
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SliderTrackView',
                qName: 'org_apache_flex_html_beads_SliderTrackView'}] };


Object.defineProperties(org_apache_flex_html_beads_SliderTrackView.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_SliderTrackView} */
        set: function(value) {
            this.strand_ = value;

            this.element = document.createElement('div');
            this.element.className = 'SliderTrack';
            this.element.id = 'track';
            this.element.style.backgroundColor = '#E4E4E4';
            this.element.style.height = '10px';
            this.element.style.width = '200px';
            this.element.style.border = 'thin solid #C4C4C4';
            this.element.style.position = 'relative';
            this.element.style.left = '0px';
            this.element.style.top = '10px';
            this.element.style.zIndex = '1';

            this.strand_.element.appendChild(this.element);

            this.positioner = this.element;
            this.element.flexjs_wrapper = this;
        }
    }
});
