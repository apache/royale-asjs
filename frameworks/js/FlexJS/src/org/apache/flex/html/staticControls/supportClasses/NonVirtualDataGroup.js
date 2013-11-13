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

goog.provide('org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup =
    function() {
  this.renderers = new Array();
  goog.base(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup,
    org.apache.flex.core.UIBase);


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup.
    prototype.set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @override
 */
org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup.
    prototype.createElement = function() {
  this.element = document.createElement('div');
  this.element.style.overflow = 'auto';
  this.set_className('NonVirtualDataGroup');

  return this.element;
};


/**
 * @override
 * @param {Object} value The child element being added.
 */
org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup.
    prototype.addElement = function(value) {
  goog.base(this, 'addElement', value);

  value.set_index(this.renderers.length);
  value.set_itemRendererParent(this);
  this.renderers.push(value);
};


/**
 * @expose
 * @param {Object} index The index for the itemRenderer.
 * @return {Object} The itemRenderer that matches the index.
 */
org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup.
    prototype.getItemRendererForIndex = function(index) {
  return this.renderers[index];
};
