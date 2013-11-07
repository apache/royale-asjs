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

goog.provide('org.apache.flex.createjs.staticControls.Label');

goog.require('org.apache.flex.createjs.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.createjs.core.UIBase}
 */
org.apache.flex.createjs.staticControls.Label = function() {
  org.apache.flex.createjs.core.UIBase.call(this);
};
goog.inherits(org.apache.flex.createjs.staticControls.Label,
    org.apache.flex.createjs.core.UIBase);


/**
 * @override
 * @this {org.apache.flex.createjs.staticControls.Label}
 */
org.apache.flex.createjs.staticControls.Label.prototype.createElement =
    function(p) {
  goog.base(this, 'createElement');

  this.element = new createjs.Text('default text', '20px Arial', '#ff7700');
  this.element.x = 0;
  this.element.y = 20;
  this.element.textBaseline = 'alphabetic';
  p.addChild(this.element);
  p.getStage().update();

  this.positioner = this.element;
};


/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.Label}
 * @return {string} The text getter.
 */
org.apache.flex.createjs.staticControls.Label.prototype.get_text = function() {
  return this.element.text;
};


/**
 * @expose
 * @this {org.apache.flex.createjs.staticControls.Label}
 * @param {string} value The text setter.
 */
org.apache.flex.createjs.staticControls.Label.prototype.set_text =
    function(value) {
  this.element.text = value;
  this.element.getStage().update();
};
