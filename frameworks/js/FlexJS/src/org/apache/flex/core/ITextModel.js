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
 * org.apache.flex.core.ITextModel
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.ITextModel');

goog.require('org.apache.flex.core.IBeadModel');



/**
 * @interface
 * @extends {org.apache.flex.events.IEventDispatcher}
 * @extends {org.apache.flex.core.IBeadModel}
 */
org.apache.flex.core.ITextModel = function() {
};


/**
 * @expose
 * @param {Object} value The text content.
 */
org.apache.flex.core.ITextModel.prototype.set_text = function(value) {};


/**
 * @expose
 * @return {Object} The text content.
 */
org.apache.flex.core.ITextModel.prototype.get_text = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ITextModel.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'ITextModel', qName: 'org.apache.flex.core.ITextModel'}],
  interfaces: [org.apache.flex.events.IEventDispatcher, org.apache.flex.core.IBeadModel] };
