/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * org_apache_flex_core_ITextModel
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_ITextModel');

goog.require('org_apache_flex_core_IBeadModel');



/**
 * @interface
 * @extends {org_apache_flex_events_IEventDispatcher}
 * @extends {org_apache_flex_core_IBeadModel}
 */
org_apache_flex_core_ITextModel = function() {
};


/**
 * @expose
 * @param {Object} value The text content.
 */
org_apache_flex_core_ITextModel.prototype.set_text = function(value) {};


/**
 * @expose
 * @return {Object} The text content.
 */
org_apache_flex_core_ITextModel.prototype.get_text = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_ITextModel.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'ITextModel', qName: 'org_apache_flex_core_ITextModel'}],
  interfaces: [org_apache_flex_events_IEventDispatcher, org_apache_flex_core_IBeadModel] };
