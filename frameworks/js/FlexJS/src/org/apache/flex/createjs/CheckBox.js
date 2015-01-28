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

goog.provide('org_apache_flex_createjs_CheckBox');

goog.require('org_apache_flex_createjs_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_createjs_core_UIBase}
 */
org_apache_flex_createjs_CheckBox = function() {
  org_apache_flex_createjs_CheckBox.base(this, 'constructor');
};
goog.inherits(org_apache_flex_createjs_CheckBox,
    org_apache_flex_createjs_core_UIBase);


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_createjs_CheckBox.prototype.checkMark = null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_createjs_CheckBox.prototype.checkMarkBackground =
    null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_createjs_CheckBox.prototype.checkBoxLabel = null;


/**
 * @override
 */
org_apache_flex_createjs_CheckBox.prototype.createElement =
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

  this.positioner = this.element;

  return this.element;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org_apache_flex_createjs_CheckBox.prototype.get_text =
    function() {
  return this.checkBoxLabel.text;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org_apache_flex_createjs_CheckBox.prototype.set_text =
    function(value) {
  this.checkBoxLabel.text = value;
};


/**
 * @expose
 * @return {bool} The selected getter.
 */
org_apache_flex_createjs_CheckBox.prototype.get_selected =
    function() {
  return this.selected;
};


/**
 * @expose
 * @param {bool} value The selected setter.
 */
org_apache_flex_createjs_CheckBox.prototype.set_selected =
    function(value) {
  this.checkMark.visible = this.selected = value;
  this.element.getStage().update();
};


/**
 * @expose
 * @param {string|Object|goog.events.Event} event The event.
 */
org_apache_flex_createjs_CheckBox.prototype.clickHandler =
    function(event) {
  this.set_selected(!this.get_selected());
};
