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

goog.provide('org.apache.flex.core.SimpleApplication');

goog.require('org.apache.flex.core.HTMLElementWrapper');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.core.SimpleApplication = function() {
  org.apache.flex.core.SimpleApplication.base(this, 'constructor');
};
goog.inherits(org.apache.flex.core.SimpleApplication,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.SimpleApplication.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleApplication',
                qName: 'org.apache.flex.core.SimpleApplication' }] };


/**
 * @export
 */
org.apache.flex.core.SimpleApplication.prototype.start = function() {
  this.element = document.getElementsByTagName('body')[0];
  this.element.flexjs_wrapper = this;
  this.element.className = 'SimpleApplication';
};
