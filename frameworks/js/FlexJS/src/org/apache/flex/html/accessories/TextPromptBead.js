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

goog.provide('org_apache_flex_html_accessories_TextPromptBead');



/**
 * @constructor
 */
org_apache_flex_html_accessories_TextPromptBead = function() {

  /**
   * @protected
   * @type {Object}
   */
  this.promptElement = null;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_accessories_TextPromptBead.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextPromptBead',
                qName: 'org_apache_flex_html_accessories_TextPromptBead' }] };


/**
 * @expose
 * @return {string} value The new prompt.
 */
org_apache_flex_html_accessories_TextPromptBead.prototype.
    get_prompt = function() {
  return this.prompt;
};


/**
 * @expose
 * @param {string} value The new prompt.
 */
org_apache_flex_html_accessories_TextPromptBead.prototype.
    set_prompt = function(value) {
  this.prompt = value;
};


/**
 * @expose
 * @param {Object} value The new host.
 */
org_apache_flex_html_accessories_TextPromptBead.prototype.
    set_strand = function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    value.element.placeholder = this.prompt;
  }
};
