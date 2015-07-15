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
 * org_apache_flex_core_IViewport
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_IViewport');

goog.require('org_apache_flex_core_IBead');



/**
 * @interface
 * @extends {org_apache_flex_core_IBead}
 */
org_apache_flex_core_IViewport = function() {
};


Object.defineProperties(org_apache_flex_core_IViewport.prototype, {
    /** @export */
    model: {
        set: function(value) {},
        get: function() {}
    }
});


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_IViewport.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'IViewport', qName: 'org_apache_flex_core_IViewport'}],
  interfaces: [org_apache_flex_core_IBead] };
