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
 * @this {org.apache.flex.html.staticControls.Container}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.Container.prototype.addToParent =
    function(p) {
  var cb;

  this.element = document.createElement('div');

  p.internalAddChild(this.element);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
};

/**
 * @override
 * @this {org.apache.flex.html.staticControls.Container}
 * @param {Object} child The element to be added.
 */
org.apache.flex.html.staticControls.Container.prototype.childrenAdded =
    function() {

  this.dispatchEvent('childrenAdded');
};

/**
 * @this {org.apache.flex.html.staticControls.Container}
 * @return {Array} the HTML DOM element children.
 */
org.apache.flex.html.staticControls.Container.prototype.internalChildren =
    function() {

  return this.element.children;
};


