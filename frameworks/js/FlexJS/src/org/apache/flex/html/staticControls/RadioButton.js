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

goog.provide('org.apache.flex.html.staticControls.RadioButton');

goog.require('org.apache.flex.core.UIBase');

var rbCount = 0;

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.RadioButton = function() {
    org.apache.flex.core.UIBase.call(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.RadioButton, org.apache.flex.core.UIBase
);

/**
 * @override
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.addToParent = 
    function(p) {
	this.element = document.createElement('label');
	
	var rb = document.createElement('input');
	rb.type = 'radio';
	this.element.appendChild(rb);
	this.element.appendChild(document.createTextNode("radio button"));

    p.appendChild(this.element);

    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @return {string} The groupName getter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.get_groupName = function() {
    return this.element.childNodes.item(0).name;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @param {string} value The groupName setter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.set_groupName = function(value) {
    this.element.childNodes.item(0).name = value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @return {string} The text getter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.get_text = function() {
    return this.element.childNodes.item(1).nodeValue;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @param {string} value The text setter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.set_text = function(value) {
    this.element.childNodes.item(1).nodeValue = value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @return {bool} The selected getter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.get_selected = function() {
    return this.element.childNodes.item(0).checked;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @param {bool} value The selected setter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.set_selected = function(value) {
    this.element.childNodes.item(0).checked = value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @return {Object} The value getter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.get_value = function() {
    return this.element.childNodes.item(0).value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @param {Object} value The value setter.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.set_value = function(value) {
    this.element.childNodes.item(0).value = value;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @return {Object} The value of the selected RadioButton.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.get_selectedValue = function() {
    var groupName = this.element.childNodes.item(0).name;
    var buttons = document.getElementsByName(groupName);
    var n = buttons.length;
    for (var i = 0; i < n; i++)
    {
        if (buttons[i].checked)
            return buttons[i].value;
    }
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.RadioButton}
 * @param {Object} value The value of the selected RadioButton.
 */
org.apache.flex.html.staticControls.RadioButton.prototype.set_selectedValue = function(value) {
    var groupName = this.element.childNodes.item(0).name;
    var buttons = document.getElementsByName(groupName);
    var n = buttons.length;
    for (var i = 0; i < n; i++)
    {
        if (buttons[i].value == value)
        {
            buttons[i].checked = true;
            break;
        }
    }
};
