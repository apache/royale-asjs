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
goog.require('org.apache.flex.events.IEventDispatcher');



/**
 * @interface
 * @extends {org.apache.flex.events.IEventDispatcher}
 * @extends {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.core.ISelectableItemRenderer = function() {
};


Object.defineProperties(org.apache.flex.core.ISelectableItemRenderer.prototype, {
    /** @export */
    labelField: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    index: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    selected: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    hovered: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    down: {
        set: function(value) {},
        get: function() {}
    }
});


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ISelectableItemRenderer.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'ISelectableItemRenderer', qName: 'org.apache.flex.core.ISelectableItemRenderer'}],
  interfaces: [org.apache.flex.core.IItemRenderer] };
