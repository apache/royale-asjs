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

goog.provide('org.apache.flex.html.staticControls.beads.ButtonBarView');

goog.require('org.apache.flex.html.staticControls.beads.ListView');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.beads.ListView}
 */
org.apache.flex.html.staticControls.beads.ButtonBarView = function() {
  this.lastSelectedIndex = -1;
  goog.base(this);

  this.className = 'ButtonBarView';
};
goog.inherits(
    org.apache.flex.html.staticControls.beads.ButtonBarView,
    org.apache.flex.html.staticControls.beads.ListView);


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.ButtonBarView}
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.ButtonBarView.prototype.set_strand =
    function(value) {

  goog.base(this, 'set_strand', value);
  this.strand_ = value;
};
