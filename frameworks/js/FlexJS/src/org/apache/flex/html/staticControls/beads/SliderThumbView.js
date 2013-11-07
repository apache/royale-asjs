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

goog.provide('org.apache.flex.html.staticControls.beads.SliderThumbView');



/**
 * @constructor
 */
org.apache.flex.html.staticControls.beads.SliderThumbView = function() {
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.SliderThumbView}
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.beads.SliderThumbView.prototype.
    set_strand = function(value) {
  this.strand_ = value;

  this.element = document.createElement('div');
  this.element.className = 'SliderThumb';
  this.element.id = 'thumb';
  this.element.style.backgroundColor = '#949494';
  this.element.style.border = 'thin solid #747474';
  this.element.style.position = 'relative';
  this.element.style.height = '30px';
  this.element.style.width = '10px';
  this.element.style.zIndex = '2';
  this.element.style.top = '-10px';
  this.element.style.left = '20px';

  this.strand_.element.appendChild(this.element);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
};
