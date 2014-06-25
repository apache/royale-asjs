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

goog.provide('org.apache.flex.html.supportClasses.NonVirtualDataGroup');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.supportClasses.DataItemRenderer');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.supportClasses.NonVirtualDataGroup =
    function() {
  this.renderers = [];
  org.apache.flex.html.supportClasses.NonVirtualDataGroup.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.supportClasses.NonVirtualDataGroup,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.NonVirtualDataGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NonVirtualDataGroup',
                qName: 'org.apache.flex.html.supportClasses.NonVirtualDataGroup' }] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.supportClasses.NonVirtualDataGroup.
    prototype.set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @override
 */
org.apache.flex.html.supportClasses.NonVirtualDataGroup.
    prototype.createElement = function() {
  this.element = document.createElement('div');
  this.element.style.overflow = 'auto';
  this.element.style.display = 'inline-block';
  this.element.style.position = 'inherit';
  this.element.flexjs_wrapper = this;
  this.set_className('NonVirtualDataGroup');

  this.positioner = this.element;

  return this.element;
};


/**
 * @override
 * @param {Object} value The child element being added.
 */
org.apache.flex.html.supportClasses.NonVirtualDataGroup.
    prototype.addElement = function(value) {
  org.apache.flex.html.supportClasses.NonVirtualDataGroup.base(this, 'addElement', value);

  var itemRenderer = org.apache.flex.utils.Language.as(value,
                           org.apache.flex.html.supportClasses.DataItemRenderer);
  itemRenderer.set_index(this.renderers.length);
  itemRenderer.set_itemRendererParent(this);
  this.renderers.push(value);
};


/**
 * @expose
 */
org.apache.flex.html.supportClasses.NonVirtualDataGroup.
    prototype.removeAllElements = function() {

  while (this.element.hasChildNodes()) {
    this.element.removeChild(this.element.lastChild);
  }
};


/**
 * @expose
 * @param {Object} index The index for the itemRenderer.
 * @return {Object} The itemRenderer that matches the index.
 */
org.apache.flex.html.supportClasses.NonVirtualDataGroup.
    prototype.getItemRendererForIndex = function(index) {
  return this.renderers[index];
};
