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

goog.provide('org_apache_flex_createjs_Label');

goog.require('org_apache_flex_createjs_core_UIBase');



/**
 * @constructor
 * @extends {org_apache_flex_createjs_core_UIBase}
 */
org_apache_flex_createjs_Label = function() {
  org_apache_flex_createjs_core_UIBase.call(this);
};
goog.inherits(org_apache_flex_createjs_Label,
    org_apache_flex_createjs_core_UIBase);


/**
 * @override
 */
org_apache_flex_createjs_Label.prototype.createElement =
    function(p) {
  org_apache_flex_createjs_Label.base(this, 'createElement');

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
 * @return {string} The text getter.
 */
org_apache_flex_createjs_Label.prototype.get_text = function() {
  return this.element.text;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org_apache_flex_createjs_Label.prototype.set_text =
    function(value) {
  this.element.text = value;
  this.element.getStage().update();
};
