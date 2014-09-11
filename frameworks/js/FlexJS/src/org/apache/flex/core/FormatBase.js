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

/**
 * @fileoverview
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.FormatBase');

goog.require('org.apache.flex.core.IFormatBead');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @implements {org.apache.flex.core.IFormatBead}
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.core.FormatBase = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.core.FormatBase,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.FormatBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'FormatBase',
                qName: 'org.apache.flex.core.FormatBase' }],
      interfaces: [org.apache.flex.core.IFormatBead] };


/**
 * @private
 * @type {org.apache.flex.core.IStrand}
 */
org.apache.flex.core.FormatBase.prototype.strand_ = null;


/**
 * @expose
 * @param {org.apache.flex.core.IStrand} value
 */
org.apache.flex.core.FormatBase.prototype.set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @type {string}
 */
org.apache.flex.core.FormatBase.prototype._propertyName = 'text';


/**
 * @type {string}
 */
org.apache.flex.core.FormatBase.prototype._eventName = 'textChange';


/**
 * @type {string}
 */
org.apache.flex.core.FormatBase.prototype._formattedResult = '';


/**
 * @expose
 * @return {Object}
 */
org.apache.flex.core.FormatBase.prototype.get_propertyValue = function() {
  var value = this.strand_['get_' + this.get_propertyName()]();
  return value;
};


/**
 * @expose
 * @return {string}
 */
org.apache.flex.core.FormatBase.prototype.get_propertyName = function() {
  if (this._propertyName == null) {
    this._propertyName = 'text';
  }
  return this._propertyName;
};


/**
 * @expose
 * @param {string} value
 */
org.apache.flex.core.FormatBase.prototype.set_propertyName = function(value) {
  this._propertyName = value;
};


/**
 * @expose
 * @return {string}
 */
org.apache.flex.core.FormatBase.prototype.get_eventName = function() {
  if (this._eventName == null) {
    return this._propertyName + 'Change';
  }
  return this._eventName;
};


/**
 * @expose
 * @param {string} value
 */
org.apache.flex.core.FormatBase.prototype.set_eventName = function(value) {
  this._eventName = value;
};


/**
 * @expose
 * @return {string}
 */
org.apache.flex.core.FormatBase.prototype.get_formattedString = function() {
  return null;
};

