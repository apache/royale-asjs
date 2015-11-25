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


Object.defineProperties(org.apache.flex.core.FormatBase.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.core.FormatBase} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    /** @export */
    propertyValue: {
        /** @this {org.apache.flex.core.FormatBase} */
        get: function() {
            var value = this.strand_[this.propertyName];
            return value;
        }
    },
    /** @export */
    propertyName: {
        /** @this {org.apache.flex.core.FormatBase} */
        get: function() {
            if (this._propertyName == null) {
              this._propertyName = 'text';
            }
            return this._propertyName;
        },
        /** @this {org.apache.flex.core.FormatBase} */
        set: function(value) {
            this._propertyName = value;
        }
    },
    /** @export */
    eventName: {
        /** @this {org.apache.flex.core.FormatBase} */
        get: function() {
            if (this._eventName == null) {
                 return this._propertyName + 'Change';
            }
            return this._eventName;
        },
        /** @this {org.apache.flex.core.FormatBase} */
        set: function(value) {
            this._eventName = value;
        }
    },
    /** @export */
    formattedString: {
        /** @this {org.apache.flex.core.FormatBase} */
        get: function() {
             return null;
        }
    }
});
