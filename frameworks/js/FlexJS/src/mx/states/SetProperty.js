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



/**
 * @constructor
 */
mx.states.SetProperty = function() {
};


/**
 * @this {mx.states.SetProperty}
 * @param {Object} document The MXML object.
 */
mx.states.SetProperty.prototype.setDocument = function(document) {
  this.document = document;
};


/**
 * @type {string} document The type of override.
 */
mx.states.SetProperty.prototype.type = 'SetProperty';


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

