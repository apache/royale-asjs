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

goog.provide('org.apache.flex.createjs.staticControls.CheckBox');

goog.require('org.apache.flex.createjs.core.UIBase');

/**
 * @constructor
 * @extends {org.apache.flex.createjs.core.UIBase}
 */
org.apache.flex.createjs.staticControls.CheckBox = function() {
    org.apache.flex.createjs.core.UIBase.call(this);
};
goog.inherits(
    org.apache.flex.createjs.staticControls.CheckBox, org.apache.flex.createjs.core.UIBase
);

org.apache.flex.createjs.staticControls.CheckBox.prototype.checkMark = null;
org.apache.flex.createjs.staticControls.CheckBox.prototype.checkMarkBackground = null;
org.apache.flex.createjs.staticControls.CheckBox.prototype.checkBoxLabel = null;
org.apache.flex.createjs.staticControls.CheckBox.prototype.selected = false;

/**
 * @override
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @param {Object} p The parent element.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.addToParent = function(p)
{	
	this.checkMarkBackground = new createjs.Shape();
	this.checkMarkBackground.name = "checkmarkbackground";
	this.checkMarkBackground.graphics.beginFill("red").drawRoundRect(0, 0, 40, 40, 8);
	
	this.checkMark = new createjs.Shape();
	this.checkMark.name = "checkmark";
	this.checkMark.graphics.beginFill("white").drawRoundRect(0, 0, 32, 32, 6);
	this.checkMark.x = 4;
	this.checkMark.y = 4;
	this.checkMark.visible = this.selected;
		
	this.checkBoxLabel = new createjs.Text("checkbox", "20px Arial", "#ff7700");
	this.checkBoxLabel.name = "label";
	this.checkBoxLabel.textAlign = "left";
	this.checkBoxLabel.textBaseline = "middle";
	this.checkBoxLabel.x = 45;
	this.checkBoxLabel.y = 40/2;
	
	this.element = new createjs.Container();
	this.element.name = "checkbox";
	this.element.addChild(this.checkMarkBackground, this.checkBoxLabel, this.checkMark);
	p.addChild(this.element);

    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @return {string} The text getter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.get_text = function() {
    return this.checkBoxLabel.text;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @param {string} value The text setter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.set_text = function(value) {
    this.checkBoxLabel.text = value;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @return {bool} The selected getter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.get_selected = function() {
    return this.selected;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @param {bool} value The selected setter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.set_selected = function(value) {
	this.checkMark.visible = this.selected = value;
	this.element.getStage().update();
};
