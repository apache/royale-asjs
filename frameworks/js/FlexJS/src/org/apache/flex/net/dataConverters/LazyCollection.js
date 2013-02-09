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

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.FlexObject');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.net.dataConverters.LazyCollection = function() {
    org.apache.flex.FlexObject.call(this);

    /**
     * @private
     * @type {Object}
     */
    this._strand;

    /**
     * @private
     * @type {Object}
     */
    this.data;

    /**
     * @private
     * @type {Object}
     */
    this._inputParser;

    /**
     * @private
     * @type {Object}
     */

    this._itemConverter;

    /**
     * @private
     * @type {Object}
     */
    this.data;
};
goog.inherits(org.apache.flex.net.dataConverters.LazyCollection,
                org.apache.flex.FlexObject);


/**
 * @expose
 * @this {org.apache.flex.core.HTTPService}
 * @return {string} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.get_inputParser =
function() {
    return this._inputParser;
};

/**
 * @expose
 * @this {org.apache.flex.core.HTTPService}
 * @param {string} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_inputParser =
function(value) {
    this._inputParser = value;
};

/**
 * @expose
 * @this {org.apache.flex.core.HTTPService}
 * @return {string} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.get_itemConverter =
function() {
    return this._itemConverter;
};

/**
 * @expose
 * @this {org.apache.flex.core.HTTPService}
 * @param {string} value The input parser.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_itemConverter =
function(value) {
    this._itemConverter = value;
};

/**
 * @expose
 * @type {string}
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.id;

/**
 * @expose
 * @this {org.apache.flex.net.dataConverters.LazyCollection}
 * @return {string} The id.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.get_id =
function() {
    return this.id;
};

/**
 * @expose
 * @this {org.apache.flex.net.dataConverters.LazyCollection}
 * @param {object} value The new id.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_id =
function(value) {
    if (this.id != value)
    {
        this.id = value;
        // this.dispatchEvent(new Event('idChanged'));
    }
};

/**
 * @expose
 * @this {org.apache.flex.net.dataConverters.LazyCollection}
 * @param {object} value The new host.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.set_strand =
function(value) {
    if (this._strand != value)
    {
        this._strand = value;
        this._strand.addEventListener('complete',
            org.apache.flex.FlexGlobal.createProxy(
                this, this.completeHandler));
    }
};

/**
 * @protected
 * @this {org.apache.flex.net.dataConverters.LazyCollection}
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.completeHandler =
function() {
    var results = this._strand.get_data();
    this._rawData = this._inputParser.parseItems(results);
    this.data = [];
};

/**
 * @expose
 * @this {org.apache.flex.net.dataConverters.LazyCollection}
 * @param {int} index The index in the collection.
 * @return {object} An item in the collection.
 */
org.apache.flex.net.dataConverters.LazyCollection.prototype.getItemAt =
function(index) {
    if (this.data[index] == undefined)
    {
        this.data[index] = this._itemConverter.convertItem(this._rawData[index]);
    }
    return this.data[index];
};
