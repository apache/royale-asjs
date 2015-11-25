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

goog.provide('org.apache.flex.collections.LazyCollection');

goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.events.IEventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.collections.LazyCollection = function() {
  org.apache.flex.collections.LazyCollection.base(this, 'constructor');
  /**
   * @private
   * @type {Object}
   */
  this.data_ = null;

  /**
   * @private
   * @type {Object}
   */

  this.itemConverter_ = null;

  /**
   * @private
   * @type {Object}
   */
  this.inputParser_ = null;

  /**
   * @private
   * @type {Object}
   */
  this.rawData_ = null;

  /**
   * @private
   * @type {Object}
   */
  this.strand_ = null;
};
goog.inherits(org.apache.flex.collections.LazyCollection, org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.collections.LazyCollection.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'LazyCollection',
                qName: 'org.apache.flex.collections.LazyCollection'}],
      interfaces: [org.apache.flex.events.IEventDispatcher]};


Object.defineProperties(org.apache.flex.collections.LazyCollection.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.collections.LazyCollection} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
              this.strand_.addEventListener('complete',
              goog.bind(this.completeHandler, this));
            }
        }
    },
    /** @export */
    length: {
        /** @this {org.apache.flex.collections.LazyCollection} */
        get: function() {
            return this.rawData_ ? this.rawData_.length : 0;
        }
    },
    /** @export */
    inputParser: {
        /** @this {org.apache.flex.collections.LazyCollection} */
        get: function() {
            return this.inputParser_;
        },
        /** @this {org.apache.flex.collections.LazyCollection} */
        set: function(value) {
            this.inputParser_ = value;
        }
    },
    /** @export */
    itemConverter: {
        /** @this {org.apache.flex.collections.LazyCollection} */
        get: function() {
            return this.itemConverter_;
        },
        /** @this {org.apache.flex.collections.LazyCollection} */
        set: function(value) {
            this.itemConverter_ = value;
        }
    },
    /** @export */
    id: {
        /** @this {org.apache.flex.collections.LazyCollection} */
        get: function() {
            return this.id_;
        },
        /** @this {org.apache.flex.collections.LazyCollection} */
        set: function(value) {
            if (this.id_ !== value) {
              this.id_ = value;
              // this.dispatchEvent(new Event('idChanged'));
            }
        }
    }
});


/**
 * @private
 * @type {string}
 */
org.apache.flex.collections.LazyCollection.prototype.id_ = '';


/**
 * @protected
 */
org.apache.flex.collections.LazyCollection.prototype.completeHandler =
    function() {
  var results = this.strand_.data;
  this.rawData_ = this.inputParser_.parseItems(results);
  this.data_ = [];
  this.dispatchEvent('complete');
};


/**
 * @export
 * @param {number} index The index in the collection.
 * @return {Object} An item in the collection.
 */
org.apache.flex.collections.LazyCollection.prototype.getItemAt =
    function(index) {
  if (this.data_[index] === undefined) {
    this.data_[index] =
        this.itemConverter_.convertItem(this.rawData_[index]);
  }

  return this.data_[index];
};
