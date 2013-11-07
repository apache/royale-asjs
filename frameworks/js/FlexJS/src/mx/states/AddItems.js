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

goog.provide('mx.states.AddItems');



/**
 * @constructor
 */
mx.states.AddItems = function() {
};


/**
 * @this {mx.states.AddItems}
 * @param {Object} document The MXML object.
 */
mx.states.AddItems.prototype.setDocument = function(document) {
  this.document = document;
};


/**
 * @type {string} document The type of override.
 */
mx.states.AddItems.prototype.type = 'AddItems';


/**
 * @expose
 * @type {Object} document The MXML object.
 */
mx.states.AddItems.prototype.document = null;


/**
 * @expose
 * @type {Array} items The array of items to add.
 */
mx.states.AddItems.prototype.items = null;


/**
 * @expose
 * @type {Array} itemsDescriptor The descriptors for items.
 */
mx.states.AddItems.prototype.itemsDescriptor = null;


/**
 * @expose
 * @type {string} destination The id of the parent.
 */
mx.states.AddItems.prototype.destination = null;


/**
 * @expose
 * @type {string} propertyName The child property name (e.g. mxmlContent).
 */
mx.states.AddItems.prototype.propertyName = null;


/**
 * @expose
 * @type {string} position Where the item goes relative to relativeTo.
 */
mx.states.AddItems.prototype.position = null;


/**
 * @expose
 * @type {string} relativeTo The id of the child where the item goes.
 */
mx.states.AddItems.prototype.relativeTo = null;

