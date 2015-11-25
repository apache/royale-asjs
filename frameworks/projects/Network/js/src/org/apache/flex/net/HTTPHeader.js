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

goog.provide('org.apache.flex.net.HTTPHeader');



/**
 * @constructor
 * @param {string=} opt_name The name.
 * @param {string=} opt_value The value.
 */
org.apache.flex.net.HTTPHeader = function(opt_name, opt_value) {
  if (typeof opt_name !== 'undefined') {
    this.name = opt_name;
  }

  if (typeof opt_value !== 'undefined') {
    this.value = opt_value;
  }
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.net.HTTPHeader.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HTTPHeader',
                qName: 'org.apache.flex.net.HTTPHeader'}] };


/**
 * @export
 * @type {string}
 */
org.apache.flex.net.HTTPHeader.CONTENT_TYPE = 'Content-type';


/**
 * @export
 * @type {?string}
 */
org.apache.flex.net.HTTPHeader.prototype.value = null;


/**
 * @export
 * @type {?string}
 */
org.apache.flex.net.HTTPHeader.prototype.name = null;
