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

goog.provide('org.apache.flex.core.IValuesImpl');



/**
 * IValuesImpl
 *
 * @interface
 */
org.apache.flex.core.IValuesImpl = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IValuesImpl.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'IValuesImpl',
                qName: 'org.apache.flex.core.IValuesImpl' }]};


/**
 * @export
 * @param {Object} thisObject The object to fetch a value for.
 * @param {string} valueName The name of the value to fetch.
 * @param {string=} opt_state The psuedo-state if any for.
 * @param {Object=} opt_attrs The object with name value pairs that
 *                       might make a difference.
 * @return {?Object} The value.
 */
org.apache.flex.core.IValuesImpl.prototype.getValue =
  function(thisObject, valueName, opt_state, opt_attrs) {};


/**
 * @export
 * @param {Object} thisObject The object to fetch a value for.
 * @param {string} valueName The name of the value to fetch.
 * @param {string=} opt_state The psuedo-state if any for.
 * @param {Object=} opt_attrs The object with name value pairs that
 *                       might make a difference.
 * @return {Object} The new instance.
 */
org.apache.flex.core.IValuesImpl.prototype.newInstance =
function(thisObject, valueName, opt_state, opt_attrs) {};


/**
 * @export
 * @param {Object} mainclass The main class for the application.
 */
org.apache.flex.core.IValuesImpl.prototype.init = function(mainclass) {};
