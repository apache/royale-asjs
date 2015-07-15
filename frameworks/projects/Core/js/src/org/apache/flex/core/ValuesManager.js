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

goog.provide('org.apache.flex.core.ValuesManager');

goog.require('org.apache.flex.core.IValuesImpl');



/**
 * @constructor
 */
org.apache.flex.core.ValuesManager = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ValuesManager.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ValuesManager',
                qName: 'org.apache.flex.core.ValuesManager' }] };


/**
 * @export
 * @type {org.apache.flex.core.IValuesImpl}
 */
org.apache.flex.core.ValuesManager.prototype.valuesImpl = null;


Object.defineProperties(org.apache.flex.core.ValuesManager.prototype, {
    /** @export */
    valuesImpl: {
        /** @this {org.apache.flex.core.ValuesManager} */
        get: function() {
            return org.apache.flex.core.ValuesManager.valuesImpl;
        },
        /** @this {org.apache.flex.core.ValuesManager} */
        set: function(value) {
            org.apache.flex.core.ValuesManager.valuesImpl = value;
        }
    }
});
