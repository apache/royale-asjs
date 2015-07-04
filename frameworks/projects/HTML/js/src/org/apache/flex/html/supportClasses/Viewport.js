/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_html_supportClasses_Viewport');

goog.require('org_apache_flex_core_IItemRenderer');
goog.require('org_apache_flex_core_IItemRendererFactory');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_events_Event');
goog.require('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 */
org_apache_flex_html_supportClasses_Viewport =
function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_supportClasses_Viewport.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Viewport',
                qName: 'org_apache_flex_html_supportClasses_Viewport' }]};



Object.defineProperties(org_apache_flex_html_supportClasses_Viewport.prototype, {
    /** @export */
    model: {
        /** @this {org_apache_flex_html_supportClasses_Viewport} */
        get: function() {
            return this.model_;
        },
        /** @this {org_apache_flex_html_supportClasses_Viewport} */
        set: function(value) {
            this.model_ = value;
        }
    }
});
