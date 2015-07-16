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

goog.provide('org.apache.flex.html5.Label');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html5.Label = function() {
  org.apache.flex.html5.Label.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html5.Label,
    org.apache.flex.core.UIBase);


/**
 * @override
 */
org.apache.flex.html5.Label.prototype.createElement =
    function() {
  org.apache.flex.html5.Label.base(this, 'createElement');

  this.positioner = this.element;

  return this.element;
};


Object.defineProperties(org.apache.flex.html5.Label.prototype, {
    /** @export */
    text: {
        /** @this {org.apache.flex.html5.Label} */
        get: function() {
            return this.element.innerHTML;
        },
        /** @this {org.apache.flex.html5.Label} */
        set: function(value) {
            this.element.innerHTML = value;
        }
    }
});
