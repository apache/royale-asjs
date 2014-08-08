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

goog.provide('org.apache.flex.html.beads.models.TextModel');

goog.require('org.apache.flex.core.ITextModel');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.ITextModel}
 */
org.apache.flex.html.beads.models.TextModel =
    function() {
  org.apache.flex.html.beads.models.TextModel.base(this, 'constructor');
  this.className = 'TextModel';
};
goog.inherits(
    org.apache.flex.html.beads.models.TextModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.models.TextModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextModel',
                qName: 'org.apache.flex.html.beads.models.TextModel' }],
      interfaces: [org.apache.flex.core.ITextModel] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.beads.models.TextModel.prototype.
    set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @expose
 * @return {Object} value The text.
 */
org.apache.flex.html.beads.models.TextModel.prototype.
    get_text = function() {
  return this.text_;
};


/**
 * @expose
 * @param {Object} value The text.
 */
org.apache.flex.html.beads.models.TextModel.prototype.
    set_text = function(value) {
  this.text_ = value;
  this.dispatchEvent('textChanged');
};
