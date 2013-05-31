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

goog.provide('org.apache.flex.html.staticControls.ControlBar');

goog.require('org.apache.flex.html.staticControls.Container');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.Container}
 */
org.apache.flex.html.staticControls.ControlBar = function() {
  goog.base(this);
  
};
goog.inherits(org.apache.flex.html.staticControls.ControlBar,
    org.apache.flex.html.staticControls.Container);
    
    
/**
 * @override
 * @this {org.apache.flex.html.staticControls.ControlBar}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.ControlBar.prototype.addToParent =
    function(p) {

  this.element = document.createElement('div');
  this.element.style.display = "inline";
  
  p.internalAddChild(this.element);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
  
  this.set_className("ControlBar");
 }