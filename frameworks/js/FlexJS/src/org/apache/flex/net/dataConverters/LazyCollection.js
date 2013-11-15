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

goog.provide('org.apache.flex.net.dataConverters.LazyCollection');



/**
 * @constructor
 */
org.apache.flex.net.dataConverters.LazyCollection = function() {
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


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'LazyCollection',
                qName: 'org.apache.flex.net.dataConverters.LazyCollection'}] };


/**
 * @expose
 * @return {Object} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.get_inputParser =
    function() {
  return this.inputParser_;
};


/**
 * @expose
 * @param {Object} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_inputParser =
    function(value) {
  this.inputParser_ = value;
};


/**
 * @expose
 * @return {Object} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.get_itemConverter =
    function() {
  return this.itemConverter_;
};


/**
 * @expose
 * @param {Object} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_itemConverter =
    function(value) {
  this.itemConverter_ = value;
};


/**
 * @expose
 * @type {string}
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.id = '';


/**
 * @expose
 * @return {string} The id.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.get_id =
    function() {
  return this.id;
};


/**
 * @expose
 * @param {string} value The new id.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_id =
    function(value) {
  if (this.id !== value) {
    this.id = value;
    // this.dispatchEvent(new Event('idChanged'));
  }
};


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_strand =
    function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('complete',
        goog.bind(this.completeHandler, this));
  }
};


/**
 * @protected
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.completeHandler =
    function() {
  var results = this.strand_.get_data();
  this.rawData_ = this.inputParser_.parseItems(results);
  this.data_ = [];
};


/**
 * @expose
 * @param {number} index The index in the collection.
 * @return {Object} An item in the collection.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.getItemAt =
    function(index) {
  if (this.data_[index] === undefined) {
    this.data_[index] =
        this.itemConverter_.convertItem(this.rawData_[index]);
  }

  return this.data_[index];
};
