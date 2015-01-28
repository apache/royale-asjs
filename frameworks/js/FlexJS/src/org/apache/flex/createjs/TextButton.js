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

goog.provide('org_apache_flex_createjs_TextButton');

goog.require('org_apache_flex_createjs_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_createjs_core_UIBase}
 */
org_apache_flex_createjs_TextButton = function() {
  org_apache_flex_createjs_core_UIBase.call(this);
};
goog.inherits(org_apache_flex_createjs_TextButton,
    org_apache_flex_createjs_core_UIBase);


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_createjs_TextButton.prototype.buttonLabel = null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_createjs_TextButton.prototype.buttonBackground =
    null;


/**
 * @override
 */
org_apache_flex_createjs_TextButton.prototype.createElement =
    function(p) {

  this.buttonBackground = new createjs.Shape();
  this.buttonBackground.name = 'background';
  this.buttonBackground.graphics.beginFill('red').
      drawRoundRect(0, 0, 200, 60, 10);

  this.buttonLabel = new createjs.Text('button', 'bold 24px Arial',
      '#FFFFFF');
  this.buttonLabel.name = 'label';
  this.buttonLabel.textAlign = 'center';
  this.buttonLabel.textBaseline = 'middle';
  this.buttonLabel.x = 200 / 2;
  this.buttonLabel.y = 60 / 2;

  this.element = new createjs.Container();
  this.element.name = 'button';
  this.element.x = 50;
  this.element.y = 25;
  this.element.addChild(this.buttonBackground, this.buttonLabel);
  p.addChild(this.element);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org_apache_flex_createjs_TextButton.prototype.get_text =
    function() {
  return this.buttonLabel.text;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org_apache_flex_createjs_TextButton.prototype.set_text =
    function(value) {
  this.buttonLabel.text = value;
};
