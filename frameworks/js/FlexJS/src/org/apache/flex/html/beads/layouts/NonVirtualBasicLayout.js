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

goog.provide('org.apache.flex.html.beads.layouts.NonVirtualBasicLayout');

goog.require('org.apache.flex.core.IBeadLayout');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout =
    function() {
  this.strand_ = null;
  this.className = 'NonVirtualBasicLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NonVirtualBasicLayout',
                qName: 'org.apache.flex.html.beads.layouts.NonVirtualBasicLayout'}],
      interfaces: [org.apache.flex.core.IBeadLayout] };


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.
    prototype.set_strand = function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('childrenAdded',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('layoutNeeded',
        goog.bind(this.changeHandler, this));
  }
};


/**
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.beads.layouts.NonVirtualBasicLayout.
    prototype.changeHandler = function(event) {
};
