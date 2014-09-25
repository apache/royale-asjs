/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.core.DataBindingBase');



/**
 * @constructor
 */
org.apache.flex.core.DataBindingBase = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.DataBindingBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataBindingBase',
                qName: 'org.apache.flex.core.DataBindingBase'}] };


/**
 * @expose
 * @param {Object} obj The object.
 * @param {string} propName The name of the property.
 * @return {Object} value The value of the property.
 */
org.apache.flex.core.DataBindingBase.prototype.getProperty =
    function(obj, propName) {
  if (typeof obj['get_' + propName] === 'function') {
    return obj['get_' + propName]();
  }
  return obj[propName];
};


/**
 * @expose
 * @param {Object} obj The object.
 * @param {string} propName The name of the property.
 * @param {Object} value The value of the property.
 */
org.apache.flex.core.DataBindingBase.prototype.setProperty =
function(obj, propName, value) {
  if (typeof obj['set_' + propName] === 'function') {
    obj['set_' + propName](value);
  } else {
    obj[propName] = value;
  }
};

