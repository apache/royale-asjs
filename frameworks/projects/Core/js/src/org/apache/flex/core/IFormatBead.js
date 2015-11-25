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

goog.provide('org.apache.flex.core.IFormatBead');

goog.require('org.apache.flex.core.IBead');
goog.require('org.apache.flex.events.IEventDispatcher');



/**
 * @interface
 * @extends {org.apache.flex.core.IBead}
 * @extends {org.apache.flex.events.IEventDispatcher}
 */
org.apache.flex.core.IFormatBead = function() {
};


Object.defineProperties(org.apache.flex.core.IFormatBead.prototype, {
    /** @export */
    propertyName: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    eventName: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    formattedString: {
        get: function() {}
    }
});


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IFormatBead.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'IFormatBead', qName: 'org.apache.flex.core.IFormatBead'}],
  interfaces: [org.apache.flex.core.IBead, org.apache.flex.events.IEventDispatcher]
};
