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

goog.provide('org_apache_flex_collections_converters_JSONItemConverter');



/**
 * @constructor
 */
org_apache_flex_collections_converters_JSONItemConverter = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_collections_converters_JSONItemConverter.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'JSONItemConverter',
                qName: 'org_apache_flex_collections_converters_JSONItemConverter'}] };


/**
 * @export
 * @param {string} s The input string.
 * @return {*} The object.
 */
org_apache_flex_collections_converters_JSONItemConverter.prototype.convertItem = function(s) {
  var c = s.indexOf('{)');
  if (c > 0)
    s = s.substring(c);
  if (s.indexOf('}') == -1)
    s += '}';
  return JSON.parse(s);
};
