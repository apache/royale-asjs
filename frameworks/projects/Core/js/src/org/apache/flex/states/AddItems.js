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

goog.provide('org.apache.flex.states.AddItems');

goog.require('org.apache.flex.core.IDocument');



/**
 * @constructor
 * @implements {org.apache.flex.core.IDocument}
 */
org.apache.flex.states.AddItems = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.states.AddItems.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'AddItems',
                qName: 'org.apache.flex.states.AddItems' }],
      interfaces: [org.apache.flex.core.IDocument] };


/**
 * @param {Object} document The MXML object.
 * @param {?string=} opt_id The id.
 */
org.apache.flex.states.AddItems.prototype.setDocument = function(document, opt_id) {
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
 * @private
 * @type {Object} document The MXML object.
 */
org.apache.flex.states.AddItems.prototype.document_ = null;


/**
 * @private
 * @type {Array} items The array of items to add.
 */
org.apache.flex.states.AddItems.prototype.items_ = null;


/**
 * @private
 * @type {number} itemsDescriptor The index into the array
 *                               of itemDescriptors on the document
 */
org.apache.flex.states.AddItems.prototype.itemsDescriptorIndex_ = -1;


/**
 * @private
 * @type {Object} itemsDescriptor The descriptors for items.
 */
org.apache.flex.states.AddItems.prototype.itemsDescriptor_ = null;


/**
 * @private
 * @type {string} destination The id of the parent.
 */
org.apache.flex.states.AddItems.prototype.destination_ = '';


/**
 * @private
 * @type {string} propertyName The child property name (e.g. mxmlContent).
 */
org.apache.flex.states.AddItems.prototype.propertyName_ = '';


/**
 * @private
 * @type {string} position Where the item goes relative to relativeTo.
 */
org.apache.flex.states.AddItems.prototype.position_ = '';


/**
 * @private
 * @type {?string} relativeTo The id of the child where the item goes.
 */
org.apache.flex.states.AddItems.prototype.relativeTo_ = null;


/**
 * @export
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
org.apache.flex.states.AddItems.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};


Object.defineProperties(org.apache.flex.states.AddItems.prototype,
  /** @lends {org.apache.flex.states.AddItems.prototype} */ {
  /** @export */
  document: {
    /** @this {org.apache.flex.states.AddItems} */
    get: function() {
      return this.document_;
    },

    /** @this {org.apache.flex.states.AddItems} */
    set: function(value) {
      if (value != this.document_) {
        this.document_ = value;
      }
    }
  },
  /** @export */
  items: {
    /** @this {org.apache.flex.states.AddItems} */
    get: function() {
      return this.items_;
    },

    /** @this {org.apache.flex.states.AddItems} */
    set: function(value) {
      if (value != this.items_) {
        this.items_ = value;
      }
    }
  },
  /** @export */
  itemsDescriptorIndex: {
    /** @this {org.apache.flex.states.AddItems}
        @return {number} */
    get: function() {
      return this.itemsDescriptorIndex_;
    },

    /** @this {org.apache.flex.states.AddItems}
        @param {number} value The value.  */
    set: function(value) {
      if (value != this.itemsDescriptorIndex_) {
        this.itemsDescriptorIndex_ = value;
      }
    }
  },
  /** @export */
  itemsDescriptor: {
    /** @this {org.apache.flex.states.AddItems} */
    get: function() {
      return this.itemsDescriptor_;
    },

    /** @this {org.apache.flex.states.AddItems} */
    set: function(value) {
      if (value != this.itemsDescriptor_) {
        this.itemsDescriptor_ = value;
      }
    }
  },
  /** @export */
  destination: {
    /** @this {org.apache.flex.states.AddItems} */
    get: function() {
      return this.destination_;
    },

    /** @this {org.apache.flex.states.AddItems} */
    set: function(value) {
      if (value != this.destination_) {
        this.destination_ = value;
      }
    }
  },
  /** @export */
  propertyName: {
    /** @this {org.apache.flex.states.AddItems} */
    get: function() {
      return this.propertyName_;
    },

    /** @this {org.apache.flex.states.AddItems} */
    set: function(value) {
      if (value != this.propertyName_) {
        this.propertyName_ = value;
      }
    }
  },
  /** @export */
  position: {
    /** @this {org.apache.flex.states.AddItems} */
    get: function() {
      return this.position_;
    },

    /** @this {org.apache.flex.states.AddItems} */
    set: function(value) {
      if (value != this.position_) {
        this.position_ = value;
      }
    }
  },
  /** @export */
  relativeTo: {
    /** @this {org.apache.flex.states.AddItems} */
    get: function() {
      return this.relativeTo_;
    },

    /** @this {org.apache.flex.states.AddItems} */
    set: function(value) {
      if (value != this.relativeTo_) {
        this.relativeTo_ = value;
      }
    }
  }
});

