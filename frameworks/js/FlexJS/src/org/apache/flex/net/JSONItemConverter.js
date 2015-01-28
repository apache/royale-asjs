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

goog.provide('org_apache_flex_net_JSONItemConverter');



/**
 * @constructor
 */
org_apache_flex_net_JSONItemConverter = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_net_JSONItemConverter.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'JSONItemConverter',
                qName: 'org_apache_flex_net_JSONItemConverter'}] };


/**
 * @expose
 * @param {string} s The input string.
 * @return {*} The object.
 */
org_apache_flex_net_JSONItemConverter.prototype.convertItem = function(s) {
  var c = s.indexOf('{)');
  if (c > 0)
    s = s.substring(c);
  if (s.indexOf('}') == -1)
    s += '}';
  return JSON.parse(s);
};


/**
 * @expose
 * @param {Object} obj The object.
 * @param {string} propName The name of the property.
 * @return {Object} value The value of the property.
 */
org_apache_flex_net_JSONItemConverter.prototype.getProperty =
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
org_apache_flex_net_JSONItemConverter.prototype.setProperty =
function(obj, propName, value) {
  if (typeof obj['set_' + propName] === 'function') {
    obj['set_' + propName](value);
  } else {
    obj[propName] = value;
  }
};

