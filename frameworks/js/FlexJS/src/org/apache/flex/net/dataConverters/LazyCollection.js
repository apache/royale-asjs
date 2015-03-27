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

goog.provide('org_apache_flex_net_dataConverters_LazyCollection');

goog.require('org_apache_flex_events_EventDispatcher');
goog.require('org_apache_flex_events_IEventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_net_dataConverters_LazyCollection = function() {
  org_apache_flex_net_dataConverters_LazyCollection.base(this, 'constructor');
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
goog.inherits(org_apache_flex_net_dataConverters_LazyCollection, org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_net_dataConverters_LazyCollection.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'LazyCollection',
                qName: 'org_apache_flex_net_dataConverters_LazyCollection'}],
      interfaces: [org_apache_flex_events_IEventDispatcher]};


Object.defineProperties(org_apache_flex_net_dataConverters_LazyCollection.prototype, {
    'strand': {
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
              this.strand_.addEventListener('complete',
              goog.bind(this.completeHandler, this));
            }
        }
    },
    'length': {
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
        get: function() {
            return this.rawData_ ? this.rawData_.length : 0;
        }
    },
    'inputParser': {
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
        get: function() {
            return this.inputParser_;
        },
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
        set: function(value) {
            this.inputParser_ = value;
        }
    },
    'itemConverter': {
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
        get: function() {
            return this.itemConverter_;
        },
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
        set: function(value) {
            this.itemConverter_ = value;
        }
    },
    'id': {
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
        get: function() {
            return this.id_;
        },
        /** @this {org_apache_flex_net_dataConverters_LazyCollection} */
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
org_apache_flex_net_dataConverters_LazyCollection.prototype.id_ = '';


/**
 * @protected
 */
org_apache_flex_net_dataConverters_LazyCollection.prototype.completeHandler =
    function() {
  var results = this.strand_.data;
  this.rawData_ = this.inputParser_.parseItems(results);
  this.data_ = [];
  this.dispatchEvent('complete');
};


/**
 * @expose
 * @param {number} index The index in the collection.
 * @return {Object} An item in the collection.
 */
org_apache_flex_net_dataConverters_LazyCollection.prototype.getItemAt =
    function(index) {
  if (this.data_[index] === undefined) {
    this.data_[index] =
        this.itemConverter_.convertItem(this.rawData_[index]);
  }

  return this.data_[index];
};
