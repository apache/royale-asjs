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

goog.provide('org.apache.flex.html.staticControls.Panel');

goog.require('org.apache.flex.html.staticControls.Container');
goog.require('org.apache.flex.html.staticControls.TitleBar');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.Container}
 */
org.apache.flex.html.staticControls.Panel = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.Panel,
    org.apache.flex.html.staticControls.Container);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.Panel}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.Panel.prototype.addToParent =
    function(p) {
  var cb;

  this.element = document.createElement('div');
  
  this.titleBar = new org.apache.flex.html.staticControls.TitleBar();
  this.titleBar.addToParent(this);
  this.titleBar.title = "Sample Panel";

  p.internalAddChild(this.element);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Panel}
 * @return {string} The title getter.
 */
org.apache.flex.html.staticControls.Panel.prototype.get_title = function() {
  return this.titleBar.get_title();
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Panel}
 * @param {string} value The title setter.
 */
org.apache.flex.html.staticControls.Panel.prototype.set_title =
    function(value) {
  this.titleBar.set_title(value);
};