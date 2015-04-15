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
 * org_apache_flex_core_IContainer
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_IContainer');

goog.require('org_apache_flex_core_IParent');



/**
 * @interface
 * @extends {org_apache_flex_core_IParent}
 */
org_apache_flex_core_IContainer = function() {
};


/**
 * @return {Array} All of the children of the container.
 */
org_apache_flex_core_IContainer.prototype.getChildren = function() {};


/**
 * Called after all of the children have been added to the container.
 * @return {void}
 */
org_apache_flex_core_IContainer.prototype.childrenAdded = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_IContainer.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'IContainer', qName: 'org_apache_flex_core_IContainer'}],
  interfaces: [org_apache_flex_core_IParent]
};
