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

goog.provide('mx_states_SetEventHandler');

goog.require('org_apache_flex_core_IDocument');



/**
 * @constructor
 * @implements {org_apache_flex_core_IDocument}
 */
mx_states_SetEventHandler = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
mx_states_SetEventHandler.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SetEventHandler',
                qName: 'mx_states_SetEventHandler' }],
      interfaces: [org_apache_flex_core_IDocument] };


/**
 * @param {Object} document The MXML object.
 * @param {?string=} opt_id The id.
 */
mx_states_SetEventHandler.prototype.setDocument = function(document, opt_id) {
  opt_id = typeof opt_id !== 'undefined' ? opt_id : null;
  this.document = document;
};


/**
 * @expose
 * @type {Object} document The MXML object.
 */
mx_states_SetEventHandler.prototype.document = null;


/**
 * @expose
 * @type {string} name The event to listen for.
 */
mx_states_SetEventHandler.prototype.name = '';


/**
 * @expose
 * @type {string} target The id of the object.
 */
mx_states_SetEventHandler.prototype.target = '';


/**
 * @expose
 * @type {Object} handlerFunction The listener to be added.
 */
mx_states_SetEventHandler.prototype.handlerFunction = null;


/**
 * @expose
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
mx_states_SetEventHandler.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};
