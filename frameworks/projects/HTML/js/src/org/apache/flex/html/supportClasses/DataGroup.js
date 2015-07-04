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

goog.provide('org_apache_flex_html_supportClasses_DataGroup');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_supportClasses_DataItemRenderer');
goog.require('org_apache_flex_utils_Language');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_supportClasses_DataGroup =
    function() {
  this.renderers = [];
  org_apache_flex_html_supportClasses_DataGroup.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_supportClasses_DataGroup,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_supportClasses_DataGroup.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataGroup',
                qName: 'org_apache_flex_html_supportClasses_DataGroup' }] };


Object.defineProperties(org_apache_flex_html_supportClasses_DataGroup.prototype, {
    /** @export */
    strand: {
        /** @this {org_apache_flex_html_supportClasses_DataGroup} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    /** @export */
    numElements: {
        /** @this {org_apache_flex_html_supportClasses_DataGroup} */
        get: function() {

            var n = this.element.childNodes.length;
            return n;
        }
    }
});


/**
 * @override
 */
org_apache_flex_html_supportClasses_DataGroup.
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
org_apache_flex_html_supportClasses_DataGroup.
    prototype.addElement = function(value) {
  org_apache_flex_html_supportClasses_DataGroup.base(this, 'addElement', value);

  var itemRenderer = org_apache_flex_utils_Language.as(value,
                           org_apache_flex_html_supportClasses_DataItemRenderer);
  itemRenderer.index = this.renderers.length;
  itemRenderer.itemRendererParent = this;
  this.renderers.push(value);
};


/**
 * @export
 */
org_apache_flex_html_supportClasses_DataGroup.
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
org_apache_flex_html_supportClasses_DataGroup.
    prototype.getElementAt = function(index) {

  var e = this.element.childNodes[index];
  return e.flexjs_wrapper;
};


/**
 * @export
 * @param {Object} index The index for the itemRenderer.
 * @return {Object} The itemRenderer that matches the index.
 */
org_apache_flex_html_supportClasses_DataGroup.
    prototype.getItemRendererForIndex = function(index) {
  return this.renderers[index];
};
