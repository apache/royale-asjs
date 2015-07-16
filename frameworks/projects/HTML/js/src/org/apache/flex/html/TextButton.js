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

goog.provide('org.apache.flex.html.TextButton');

goog.require('org.apache.flex.html.Button');



/**
 * @constructor
 * @extends {org.apache.flex.html.Button}
 */
org.apache.flex.html.TextButton = function() {
  org.apache.flex.html.TextButton.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.TextButton,
    org.apache.flex.html.Button);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.TextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextButton',
                qName: 'org.apache.flex.html.TextButton'}] };


Object.defineProperties(org.apache.flex.html.TextButton.prototype, {
    /** @export */
    text: {
        /** @this {org.apache.flex.html.TextButton} */
        get: function() {
            return this.element.innerHTML;
        },
        /** @this {org.apache.flex.html.TextButton} */
        set: function(value) {
            this.element.innerHTML = value;
        }
    }
});
