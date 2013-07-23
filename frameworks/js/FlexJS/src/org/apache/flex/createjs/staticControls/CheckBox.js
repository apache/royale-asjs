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
    goog.base(this);
};
goog.inherits(org.apache.flex.createjs.staticControls.CheckBox,
  org.apache.flex.createjs.core.UIBase);

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.checkMark = null;

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.checkMarkBackground =
  null;

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.checkBoxLabel = null;

/**
 * @override
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.createElement =
    function() {
    this.checkMarkBackground = new createjs.Shape();
    this.checkMarkBackground.name = 'checkmarkbackground';
    this.checkMarkBackground.graphics.beginFill('red').
      drawRoundRect(0, 0, 40, 40, 8);
    //this.checkMarkBackground.graphics.setStrokeStyle( 0 ).beginStroke('#000').
    //  drawRect( 0, 0, this.width, this.height);
    //var hit = new createjs.Shape();
    //hit.graphics.beginFill("#000").drawRect(0, 0, this.width, this.height);
    //this.checkMarkBackground.hitArea = hit;

    this.checkMark = new createjs.Shape();
    this.checkMark.name = 'checkmark';
    this.checkMark.graphics.beginFill('white').drawRoundRect(0, 0, 32, 32, 6);
    this.checkMark.x = 4;
    this.checkMark.y = 4;
    this.checkMark.visible = this.selected;

    this.checkBoxLabel = new createjs.Text('checkbox', '20px Arial', '#ff7700');
    this.checkBoxLabel.name = 'label';
    this.checkBoxLabel.textAlign = 'left';
    this.checkBoxLabel.textBaseline = 'middle';
    this.checkBoxLabel.x = 45;
    this.checkBoxLabel.y = 40 / 2;

    this.element = new createjs.Container();
    this.element.name = 'checkbox';
    this.element.addChild(this.checkMarkBackground, this.checkBoxLabel,
      this.checkMark);
    // use bind(this) to avoid loose scope
    this.element.onClick = this.clickHandler.bind(this);

    p.addChild(this.element);

    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @return {string} The text getter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.get_text =
  function() {
    return this.checkBoxLabel.text;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @param {string} value The text setter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.set_text =
  function(value) {
    this.checkBoxLabel.text = value;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @return {bool} The selected getter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.get_selected =
  function() {
    return this.selected;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @param {bool} value The selected setter.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.set_selected =
  function(value) {
    this.checkMark.visible = this.selected = value;
    this.element.getStage().update();
};

/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.CheckBox}
 * @param {string|Object|goog.events.Event} event The event.
 */
org.apache.flex.createjs.staticControls.CheckBox.prototype.clickHandler =
  function(event) {
    this.set_selected(!this.get_selected());
};
