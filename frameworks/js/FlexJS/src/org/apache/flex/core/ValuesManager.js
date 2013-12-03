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
 * @expose
 * @return {org.apache.flex.core.ValuesManager}
 */
org.apache.flex.core.ValuesManager.prototype.valuesImpl;


/**
 * @expose
 * @this {org.apache.flex.core.ValuesManager}
 * @return {Object} The value.
 */
org.apache.flex.core.ValuesManager.get_valuesImpl = function() {
  return org.apache.flex.core.ValuesManager.valuesImpl;
};


/**
 * @expose
 * @this {org.apache.flex.core.ValuesManager}
 * @param {Object} value being set.
 */
org.apache.flex.core.ValuesManager.set_valuesImpl = function(value) {
  org.apache.flex.core.ValuesManager.valuesImpl = value;
};
