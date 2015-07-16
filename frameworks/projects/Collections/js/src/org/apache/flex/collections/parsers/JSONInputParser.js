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

goog.provide('org.apache.flex.collections.parsers.JSONInputParser');



/**
 * @constructor
 */
org.apache.flex.collections.parsers.JSONInputParser = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.collections.parsers.JSONInputParser.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'JSONInputParser',
                qName: 'org.apache.flex.collections.parsers.JSONInputParser'}] };


/**
 * @export
 * @param {string} s The input string.
 * @return {Array.<string>} The Array of unparsed objects.
 */
org.apache.flex.collections.parsers.JSONInputParser.prototype.parseItems = function(s) {
  var c = s.indexOf('[');
  if (c != -1) {
    var c2 = s.lastIndexOf(']');
    s = s.substring(c + 1, c2);
  }
  return s.split('},');
};
