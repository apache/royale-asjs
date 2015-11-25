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

goog.provide('org.apache.flex.html.supportClasses.DataGroup');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.supportClasses.DataItemRenderer');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.supportClasses.DataGroup =
    function() {
  this.renderers = [];
  org.apache.flex.html.supportClasses.DataGroup.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.supportClasses.DataGroup,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.DataGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataGroup',
                qName: 'org.apache.flex.html.supportClasses.DataGroup' }] };


Object.defineProperties(org.apache.flex.html.supportClasses.DataGroup.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.supportClasses.DataGroup} */
        set: function(value) {
            this.strand_ = value;
        },
        /** @this {org.apache.flex.html.supportClasses.DataGroup} */
        get: function() {
            return this.strand_;
        }
    },
    /** @export */
    numElements: {
        /** @this {org.apache.flex.html.supportClasses.DataGroup} */
        get: function() {

            var n = this.element.childNodes.length;
            return n;
        }
    }
});


/**
 * @override
 */
org.apache.flex.html.supportClasses.DataGroup.
    prototype.createElement = function() {
  this.element = document.createElement('div');
  this.element.style.overflow = 'auto';
  this.element.style.display = 'inline-block';
  this.element.style.position = 'inherit';
  this.element.flexjs_wrapper = this;
  this.className = 'DataGroup';

  this.positioner = this.element;

  return this.element;
};


/**
 * @override
 * @param {Object} value The child element being added.
 */
org.apache.flex.html.supportClasses.DataGroup.
    prototype.addElement = function(value) {
  org.apache.flex.html.supportClasses.DataGroup.base(this, 'addElement', value);

  var itemRenderer = org.apache.flex.utils.Language.as(value,
                           org.apache.flex.html.supportClasses.DataItemRenderer);
  itemRenderer.index = this.renderers.length;
  itemRenderer.itemRendererParent = this;
  this.renderers.push(value);
};


/**
 * @export
 */
org.apache.flex.html.supportClasses.DataGroup.
    prototype.removeAllElements = function() {

  while (this.element.hasChildNodes()) {
    this.element.removeChild(this.element.lastChild);
  }
};


/**
 * @export
 * @param {number} index The index of the desired element.
 * @return {Object} The element at the given index.
 */
org.apache.flex.html.supportClasses.DataGroup.
    prototype.getElementAt = function(index) {

  var e = this.element.childNodes[index];
  return e.flexjs_wrapper;
};


/**
 * @export
 * @param {number} index The selected index.
 * @return {Object} The itemRenderer at the given index.
 */
org.apache.flex.html.supportClasses.DataGroup.
    prototype.getItemRendererForIndex = function(index) {
  return this.renderers[index];
};
