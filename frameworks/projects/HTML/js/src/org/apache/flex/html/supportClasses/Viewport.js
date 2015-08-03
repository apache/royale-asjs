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

goog.provide('org.apache.flex.html.supportClasses.Viewport');

goog.require('org.apache.flex.core.IBead');
goog.require('org.apache.flex.core.IViewport');



/**
 * @constructor
 */
org.apache.flex.html.supportClasses.Viewport =
function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.Viewport.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Viewport',
                qName: 'org.apache.flex.html.supportClasses.Viewport' }],
      interfaces: [org.apache.flex.core.IBead,
                   org.apache.flex.core.IViewport]};


/**
 *
 */
org.apache.flex.html.supportClasses.Viewport.prototype.updateSize = function() {
};


/**
 *
 */
org.apache.flex.html.supportClasses.Viewport.prototype.updateContentAreaSize = function() {
};


Object.defineProperties(org.apache.flex.html.supportClasses.Viewport.prototype, {
    /** @export */
    model: {
        /** @this {org.apache.flex.html.supportClasses.Viewport} */
        get: function() {
            return this.model_;
        },
        /** @this {org.apache.flex.html.supportClasses.Viewport} */
        set: function(value) {
            this.model_ = value;
        }
    }
});
