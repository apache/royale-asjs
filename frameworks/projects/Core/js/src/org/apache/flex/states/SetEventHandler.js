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

goog.provide('org.apache.flex.states.SetEventHandler');

goog.require('org.apache.flex.core.IDocument');



/**
 * @constructor
 * @implements {org.apache.flex.core.IDocument}
 */
org.apache.flex.states.SetEventHandler = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.states.SetEventHandler.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SetEventHandler',
                qName: 'org.apache.flex.states.SetEventHandler' }],
      interfaces: [org.apache.flex.core.IDocument] };


/**
 * @param {Object} document The MXML object.
 * @param {?string=} opt_id The id.
 */
org.apache.flex.states.SetEventHandler.prototype.setDocument = function(document, opt_id) {
  opt_id = typeof opt_id !== 'undefined' ? opt_id : null;
  this.document = document;
};


/**
 * @private
 * @type {Object} document The MXML object.
 */
org.apache.flex.states.SetEventHandler.prototype.document_ = null;


/**
 * @private
 * @type {string} name The event to listen for.
 */
org.apache.flex.states.SetEventHandler.prototype.name_ = '';


/**
 * @private
 * @type {string} target The id of the object.
 */
org.apache.flex.states.SetEventHandler.prototype.target_ = '';


/**
 * @private
 * @type {Object} handlerFunction The listener to be added.
 */
org.apache.flex.states.SetEventHandler.prototype.handlerFunction_ = null;


/**
 * @export
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
org.apache.flex.states.SetEventHandler.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};


Object.defineProperties(org.apache.flex.states.SetEventHandler.prototype,
  /** @lends {org.apache.flex.states.SetEventHandler.prototype} */ {
  /** @export */
  document: {
    /** @this {org.apache.flex.states.SetEventHandler} */
    get: function() {
      return this.document_;
    },

    /** @this {org.apache.flex.states.SetEventHandler} */
    set: function(value) {
      if (value != this.document_) {
        this.document_ = value;
      }
    }
  },
  /** @export */
  name: {
    /** @this {org.apache.flex.states.SetEventHandler} */
    get: function() {
      return this.name_;
    },

    /** @this {org.apache.flex.states.SetEventHandler} */
    set: function(value) {
      if (value != this.name_) {
        this.name_ = value;
      }
    }
  },
  /** @export */
  target: {
    /** @this {org.apache.flex.states.SetEventHandler} */
    get: function() {
      return this.target_;
    },

    /** @this {org.apache.flex.states.SetEventHandler} */
    set: function(value) {
      if (value != this.target_) {
        this.target_ = value;
      }
    }
  },
  /** @export */
  handlerFunction: {
    /** @this {org.apache.flex.states.SetEventHandler} */
    get: function() {
      return this.handlerFunction_;
    },

    /** @this {org.apache.flex.states.SetEventHandler} */
    set: function(value) {
      if (value != this.handlerFunction_) {
        this.handlerFunction_ = value;
      }
    }
  }
});
