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

goog.require('org.apache.flex.core.IDocument');



/**
 * @constructor
 * @implements {org.apache.flex.core.IDocument}
 */
mx.states.AddItems = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
mx.states.AddItems.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'AddItems',
                qName: 'mx.states.AddItems' }],
      interfaces: [org.apache.flex.core.IDocument] };


/**
 * @param {Object} document The MXML object.
 * @param {?string=} opt_id The id.
 */
mx.states.AddItems.prototype.setDocument = function(document, opt_id) {
  opt_id = typeof opt_id !== 'undefined' ? opt_id : null;
  this.document = document;
};


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
mx.states.AddItems.prototype.destination = '';


/**
 * @expose
 * @type {string} propertyName The child property name (e.g. mxmlContent).
 */
mx.states.AddItems.prototype.propertyName = '';


/**
 * @expose
 * @type {string} position Where the item goes relative to relativeTo.
 */
mx.states.AddItems.prototype.position = '';


/**
 * @expose
 * @type {string} relativeTo The id of the child where the item goes.
 */
mx.states.AddItems.prototype.relativeTo = '';


/**
 * @expose
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
mx.states.AddItems.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};
