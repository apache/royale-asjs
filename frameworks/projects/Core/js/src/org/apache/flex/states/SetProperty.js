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

goog.provide('org_apache_flex_states_SetProperty');

goog.require('org_apache_flex_core_IDocument');



/**
 * @constructor
 * @implements {org_apache_flex_core_IDocument}
 */
org_apache_flex_states_SetProperty = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_states_SetProperty.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SetProperty',
                qName: 'org_apache_flex_states_SetProperty' }],
      interfaces: [org_apache_flex_core_IDocument] };


/**
 * @param {Object} document The MXML object.
 * @param {?string=} opt_id The id.
 */
org_apache_flex_states_SetProperty.prototype.setDocument = function(document, opt_id) {
  opt_id = typeof opt_id !== 'undefined' ? opt_id : null;
  this.document = document;
};


/**
 * @expose
 * @type {Object} document The MXML object.
 */
org_apache_flex_states_SetProperty.prototype.document = null;


/**
 * @expose
 * @type {string} name The target property name.
 */
org_apache_flex_states_SetProperty.prototype.name = '';


/**
 * @expose
 * @type {?string} target The id of the object.
 */
org_apache_flex_states_SetProperty.prototype.target = null;


/**
 * @expose
 * @type {Object} previousValue The value to revert to.
 */
org_apache_flex_states_SetProperty.prototype.previousValue = null;


/**
 * @expose
 * @type {Object} value The value to set.
 */
org_apache_flex_states_SetProperty.prototype.value = null;


/**
 * @expose
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
org_apache_flex_states_SetProperty.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};
