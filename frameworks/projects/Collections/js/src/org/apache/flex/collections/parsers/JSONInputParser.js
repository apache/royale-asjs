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

goog.provide('org_apache_flex_collections_parsers_JSONInputParser');



/**
 * @constructor
 */
org_apache_flex_collections_parsers_JSONInputParser = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_collections_parsers_JSONInputParser.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'JSONInputParser',
                qName: 'org_apache_flex_collections_parsers_JSONInputParser'}] };


/**
 * @expose
 * @param {string} s The input string.
 * @return {Array.<string>} The Array of unparsed objects.
 */
org_apache_flex_collections_parsers_JSONInputParser.prototype.parseItems = function(s) {
  var c = s.indexOf('[');
  if (c != -1) {
    var c2 = s.lastIndexOf(']');
    s = s.substring(c + 1, c2);
  }
  return s.split('},');
};
