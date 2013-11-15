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

goog.provide('org.apache.flex.net.JSONInputParser');



/**
 * @constructor
 */
org.apache.flex.net.JSONInputParser = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.net.JSONInputParser.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'JSONInputParser',
                qName: 'org.apache.flex.net.JSONInputParser'}] };


/**
 * @expose
 * @param {string} s The input string.
 * @return {Array.<string>} The Array of unparsed objects.
 */
org.apache.flex.net.JSONInputParser.prototype.parseItems = function(s) {
  return s.split('},');
};
