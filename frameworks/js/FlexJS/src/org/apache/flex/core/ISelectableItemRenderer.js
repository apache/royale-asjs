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
 * org_apache_flex_core_ISelectableItemRenderer
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_ISelectableItemRenderer');

goog.require('org_apache_flex_core_IItemRenderer');



/**
 * @interface
 * @extends {org_apache_flex_events_IEventDispatcher}
 * @extends {org_apache_flex_core_IItemRenderer}
 */
org_apache_flex_core_ISelectableItemRenderer = function() {
};


Object.defineProperties(org_apache_flex_core_ISelectableItemRenderer.prototype, {
    /** @expose */
    labelField: {
        set: function(value) {},
        get: function() {}
    },
    /** @expose */
    index: {
        set: function(value) {},
        get: function() {}
    },
    /** @expose */
    selected: {
        set: function(value) {},
        get: function() {}
    },
    /** @expose */
    hovered: {
        set: function(value) {},
        get: function() {}
    },
    /** @expose */
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
org_apache_flex_core_ISelectableItemRenderer.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'ISelectableItemRenderer', qName: 'org_apache_flex_core_ISelectableItemRenderer'}],
  interfaces: [org_apache_flex_core_IItemRenderer] };
