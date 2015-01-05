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
 * org.apache.flex.core.ISelectableItemRenderer
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.ISelectableItemRenderer');

goog.require('org.apache.flex.core.IItemRenderer');



/**
 * @interface
 * @extends {org.apache.flex.events.IEventDispatcher}
 * @extends {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.core.ISelectableItemRenderer = function() {
};


/**
 * @expose
 * @param {Object} value
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.set_labelField = function(value) {};


/**
 * @expose
 * @return {Object} The labelField.
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.get_labelField = function() {};


/**
 * @expose
 * @param {number} value
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.set_index = function(value) {};


/**
 * @expose
 * @return {number} The selected index.
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.get_index = function() {};


/**
 * @expose
 * @param {Object} value
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.set_selected = function(value) {};


/**
 * @expose
 * @return {Object} Whether or not the item in the selected state.
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.get_selected = function() {};


/**
 * @expose
 * @param {Object} value
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.set_hovered = function(value) {};


/**
 * @expose
 * @return {Object} Whether or not the item is in the hovered state.
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.get_hovered = function() {};


/**
 * @expose
 * @param {Object} value
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.set_down = function(value) {};


/**
 * @expose
 * @return {Object} Whether or not the item is in the down state.
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.get_down = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'ISelectableItemRenderer', qName: 'org.apache.flex.core.ISelectableItemRenderer'}],
  interfaces: [org.apache.flex.core.IItemRenderer] };
