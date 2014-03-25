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

goog.provide('org.apache.flex.html5.staticControls.TextButton');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html5.staticControls.TextButton = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html5.staticControls.TextButton,
    org.apache.flex.core.UIBase);


/**
 * @override
 */
org.apache.flex.html5.staticControls.TextButton.prototype.createElement =
    function() {
  this.element = document.createElement('button');
  this.element.setAttribute('type', 'button');

  this.positioner = this.element;

  return this.element;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org.apache.flex.html5.staticControls.TextButton.prototype.get_text =
    function() {
  return this.element.innerHTML;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org.apache.flex.html5.staticControls.TextButton.prototype.set_text =
    function(value) {
  this.element.innerHTML = value;
};
