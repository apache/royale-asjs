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
 * org.apache.flex.core.IContainer
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.IContainer');

goog.require('org.apache.flex.core.IParent');



/**
 * @interface
 * @extends {org.apache.flex.core.IParent}
 */
org.apache.flex.core.IContainer = function() {
};


/**
 * @return {Array} All of the children of the container.
 */
org.apache.flex.core.IContainer.prototype.getChildren = function() {};


/**
 * Called after all of the children have been added to the container.
 * @return {void}
 */
org.apache.flex.core.IContainer.prototype.childrenAdded = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IContainer.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'IContainer', qName: 'org.apache.flex.core.IContainer'}],
  interfaces: [org.apache.flex.core.IParent]
};
