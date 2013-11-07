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

goog.provide('mx.states.SetProperty');

goog.require('org.apache.flex.core.IDocument');



/**
 * @constructor
 * @implements {org.apache.flex.core.IDocument}
 */
mx.states.SetProperty = function() {
};


/**
 * @param {Object} document The MXML object.
 * @param {string=} opt_id The id.
 */
mx.states.SetProperty.prototype.setDocument = function(document, opt_id) {
  opt_id = typeof opt_id !== 'undefined' ? opt_id : null;
  this.document = document;
};


/**
 * @expose
 * @type {Object} document The MXML object.
 */
mx.states.SetProperty.prototype.document = null;


/**
 * @expose
 * @type {string} name The target property name.
 */
mx.states.SetProperty.prototype.name = null;


/**
 * @expose
 * @type {string} target The id of the object.
 */
mx.states.SetProperty.prototype.target = null;


/**
 * @expose
 * @type {Object} previousValue The value to revert to.
 */
mx.states.SetProperty.prototype.previousValue = null;


/**
 * @expose
 * @type {Object} value The value to set.
 */
mx.states.SetProperty.prototype.value = null;


/**
 * @expose
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
mx.states.SetProperty.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};


/**
 * @const
 */
mx.states.SetProperty.prototype.FLEXJS_CLASS_INFO =
    { interfaces: [org.apache.flex.core.IDocument] };
