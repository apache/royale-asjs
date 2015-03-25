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

goog.provide('org_apache_flex_utils_ViewSourceContextMenuOption');

goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_utils_ViewSourceContextMenuOption = function() {
  // no implementation in JS since ViewSource is already in menu
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_utils_ViewSourceContextMenuOption.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ViewSourceContextMenuOption',
                qName: 'org_apache_flex_utils_ViewSourceContextMenuOption'}] };


Object.defineProperties(org_apache_flex_utils_ViewSourceContextMenuOption.prototype, {
    'strand': {
        /** @this {org_apache_flex_utils_ViewSourceContextMenuOption} */
        set: function(value) {}
	}
});

