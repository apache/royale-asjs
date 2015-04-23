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

goog.provide('org_apache_flex_states_AddItems');

goog.require('org_apache_flex_core_IDocument');



/**
 * @constructor
 * @implements {org_apache_flex_core_IDocument}
 */
org_apache_flex_states_AddItems = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_states_AddItems.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'AddItems',
                qName: 'org_apache_flex_states_AddItems' }],
      interfaces: [org_apache_flex_core_IDocument] };


/**
 * @param {Object} document The MXML object.
 * @param {?string=} opt_id The id.
 */
org_apache_flex_states_AddItems.prototype.setDocument = function(document, opt_id) {
  opt_id = typeof opt_id !== 'undefined' ? opt_id : null;
  this.document = document;
  var data = document['mxmlsd'][this.itemsDescriptorIndex];
  if (typeof(data.slice) == 'function') {
    this.itemsDescriptor = {};
    this.itemsDescriptor.descriptor = data;
    // replace the entry in the document so subsequent
    // addItems know it is shared
    this.document['mxmlsd'][this.itemsDescriptorIndex] = this.itemsDescriptor;
  } else
    this.itemsDescriptor = data;
};


/**
 * @expose
 * @type {Object} document The MXML object.
 */
org_apache_flex_states_AddItems.prototype.document = null;


/**
 * @expose
 * @type {Array} items The array of items to add.
 */
org_apache_flex_states_AddItems.prototype.items = null;


/**
 * @expose
 * @type {number} itemsDescriptor The index into the array
 *                               of itemDescriptors on the document
 */
org_apache_flex_states_AddItems.prototype.itemsDescriptorIndex = -1;


/**
 * @expose
 * @type {Object} itemsDescriptor The descriptors for items.
 */
org_apache_flex_states_AddItems.prototype.itemsDescriptor = null;


/**
 * @expose
 * @type {string} destination The id of the parent.
 */
org_apache_flex_states_AddItems.prototype.destination = '';


/**
 * @expose
 * @type {string} propertyName The child property name (e.g. mxmlContent).
 */
org_apache_flex_states_AddItems.prototype.propertyName = '';


/**
 * @expose
 * @type {string} position Where the item goes relative to relativeTo.
 */
org_apache_flex_states_AddItems.prototype.position = '';


/**
 * @expose
 * @type {?string} relativeTo The id of the child where the item goes.
 */
org_apache_flex_states_AddItems.prototype.relativeTo = null;


/**
 * @expose
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
org_apache_flex_states_AddItems.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};
