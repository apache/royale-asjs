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
 * org.apache.flex.core.IContentView
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.IContentView');



/**
 * @interface
 */
org.apache.flex.core.IContentView = function() {
};


/**
 * @return {number} x position.
 */
org.apache.flex.core.IContentView.prototype.get_x = function() {};


/**
 * @param {number} value x position.
 */
org.apache.flex.core.IContentView.prototype.set_x = function(value) {};


/**
 * @return {number} y position.
 */
org.apache.flex.core.IContentView.prototype.get_y = function() {};


/**
 * @param {number} value y position.
 */
org.apache.flex.core.IContentView.prototype.set_y = function(value) {};


/**
 * @return {number} Component width.
 */
org.apache.flex.core.IContentView.prototype.get_width = function() {};


/**
 * @param {number} value Component width.
 */
org.apache.flex.core.IContentView.prototype.set_width = function(value) {};


/**
 * @return {number} Component height.
 */
org.apache.flex.core.IContentView.prototype.get_height = function() {};


/**
 * @param {number} value Component height.
 */
org.apache.flex.core.IContentView.prototype.set_height = function(value) {};


/**
 * Adds a new element to component.
 * @param {Object} value The child element being added.
 */
org.apache.flex.core.IContentView.prototype.addElement = function(value) {};


/**
 * Removes all of the component's children.
 * @return {void}
 */
org.apache.flex.core.IContentView.prototype.removeAllElements = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IContentView.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'IContentView', qName: 'org.apache.flex.core.IContentView'}]
};
