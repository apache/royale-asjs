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

goog.provide('org.apache.flex.collections.converters.JSONItemConverter');



/**
 * @constructor
 */
org.apache.flex.collections.converters.JSONItemConverter = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.collections.converters.JSONItemConverter.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'JSONItemConverter',
                qName: 'org.apache.flex.collections.converters.JSONItemConverter'}] };


/**
 * @export
 * @param {string} s The input string.
 * @return {*} The object.
 */
org.apache.flex.collections.converters.JSONItemConverter.prototype.convertItem = function(s) {
  var c = s.indexOf('{)');
  if (c > 0)
    s = s.substring(c);
  if (s.indexOf('}') == -1)
    s += '}';
  return JSON.parse(s);
};
