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

goog.provide('org.apache.flex.html.staticControls.accessories.TextPromptBead');



/**
 * @constructor
 */
org.apache.flex.html.staticControls.accessories.TextPromptBead = function() {

  /**
   * @private
   * @type {Object}
   */
  this.promptElement;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.accessories.TextPromptBead.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextPromptBead',
                qName: 'org.apache.flex.html.staticControls.accessories.TextPromptBead' }] };


/**
 * @expose
 * @return {string} value The new prompt.
 */
org.apache.flex.html.staticControls.accessories.TextPromptBead.prototype.
    get_prompt = function() {
  return this.prompt;
};


/**
 * @expose
 * @param {string} value The new prompt.
 */
org.apache.flex.html.staticControls.accessories.TextPromptBead.prototype.
    set_prompt = function(value) {
  this.prompt = value;
};


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.accessories.TextPromptBead.prototype.
    set_strand = function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    value.element.placeholder = this.prompt;
  }
};
