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

goog.provide('org.apache.flex.html.staticControls.Container');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.Container = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.Container,
    org.apache.flex.core.UIBase);


/**
 * @override
 */
org.apache.flex.html.staticControls.Container.prototype.createElement =
    function() {
  var cb;

  this.element = document.createElement('div');

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @override
 */
org.apache.flex.html.staticControls.Container.prototype.addElement =
    function(child) {
  goog.base(this, 'addElement', child);
  this.dispatchEvent('elementAdded');
};


/**
 * @expose
 */
org.apache.flex.html.staticControls.Container.prototype.childrenAdded =
    function() {
  this.dispatchEvent('childrenAdded');
};


/**
 * @expose
 * @return {Array} the HTML DOM element children.
 */
org.apache.flex.html.staticControls.Container.prototype.internalChildren =
    function() {
  return this.element.children;
};


