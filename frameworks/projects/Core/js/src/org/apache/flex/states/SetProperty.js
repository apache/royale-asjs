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

goog.provide('org.apache.flex.states.SetProperty');

goog.require('org.apache.flex.core.IDocument');



/**
 * @constructor
 * @implements {org.apache.flex.core.IDocument}
 */
org.apache.flex.states.SetProperty = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.states.SetProperty.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SetProperty',
                qName: 'org.apache.flex.states.SetProperty' }],
      interfaces: [org.apache.flex.core.IDocument] };


/**
 * @param {Object} document The MXML object.
 * @param {?string=} opt_id The id.
 */
org.apache.flex.states.SetProperty.prototype.setDocument = function(document, opt_id) {
  opt_id = typeof opt_id !== 'undefined' ? opt_id : null;
  this.document = document;
};


/**
 * @private
 * @type {Object} document The MXML object.
 */
org.apache.flex.states.SetProperty.prototype.document_ = null;


/**
 * @private
 * @type {string} name The target property name.
 */
org.apache.flex.states.SetProperty.prototype.name_ = '';


/**
 * @private
 * @type {?string} target The id of the object.
 */
org.apache.flex.states.SetProperty.prototype.target_ = null;


/**
 * @private
 * @type {Object} previousValue The value to revert to.
 */
org.apache.flex.states.SetProperty.prototype.previousValue_ = null;


/**
 * @private
 * @type {Object} value The value to set.
 */
org.apache.flex.states.SetProperty.prototype.value_ = null;


/**
 * @export
 * @param {Object} properties The properties for the new object.
 * @return {Object} The new object.
 */
org.apache.flex.states.SetProperty.prototype.initializeFromObject = function(properties) {
  var p;

  for (p in properties) {
    this[p] = properties[p];
  }

  return this;
};


Object.defineProperties(org.apache.flex.states.SetProperty.prototype,
  /** @lends {org.apache.flex.states.SetProperty.prototype} */ {
  /** @export */
  document: {
    /** @this {org.apache.flex.states.SetProperty} */
    get: function() {
      return this.document_;
    },

    /** @this {org.apache.flex.states.SetProperty} */
    set: function(value) {
      if (value != this.document_) {
        this.document_ = value;
      }
    }
  },
  /** @export */
  name: {
    /** @this {org.apache.flex.states.SetProperty} */
    get: function() {
      return this.name_;
    },

    /** @this {org.apache.flex.states.SetProperty} */
    set: function(value) {
      if (value != this.name_) {
        this.name_ = value;
      }
    }
  },
  /** @export */
  target: {
    /** @this {org.apache.flex.states.SetProperty} */
    get: function() {
      return this.target_;
    },

    /** @this {org.apache.flex.states.SetProperty} */
    set: function(value) {
      if (value != this.target_) {
        this.target_ = value;
      }
    }
  },
  /** @export */
  previousValue: {
    /** @this {org.apache.flex.states.SetProperty} */
    get: function() {
      return this.previousValue_;
    },

    /** @this {org.apache.flex.states.SetProperty} */
    set: function(value) {
      if (value != this.previousValue_) {
        this.previousValue_ = value;
      }
    }
  },
  /** @export */
  value: {
    /** @this {org.apache.flex.states.SetProperty} */
    get: function() {
      return this.value_;
    },

    /** @this {org.apache.flex.states.SetProperty} */
    set: function(value) {
      if (value != this.value_) {
        this.value_ = value;
      }
    }
  }
});
