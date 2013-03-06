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

goog.provide('org.apache.flex.html.staticControls.CheckBox');

goog.require('org.apache.flex.core.UIBase');

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.CheckBox = function() {
    org.apache.flex.core.UIBase.call(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.CheckBox, org.apache.flex.core.UIBase
);

/**
 * @override
 * @this {org.apache.flex.html.staticControls.CheckBox}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.CheckBox.prototype.addToParent = 
    function(p) {
    this.element = document.createElement('input');
    this.element.type = "checkbox";

    p.appendChild(this.element);

    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.CheckBox}
 * @return {string} The text getter.
 */
org.apache.flex.html.staticControls.CheckBox.prototype.get_text = function() {
    return this.element.value
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.CheckBox}
 * @param {string} value The text setter.
 */
org.apache.flex.html.staticControls.CheckBox.prototype.set_text = function(value) {
    this.element.value = value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.CheckBox}
 * @return {bool} The selected getter.
 */
org.apache.flex.html.staticControls.CheckBox.prototype.get_selected = function() {
    return this.element.checked
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.CheckBox}
 * @param {bool} value The selected setter.
 */
org.apache.flex.html.staticControls.CheckBox.prototype.set_selected = function(value) {
    this.element.checked = value;
};
