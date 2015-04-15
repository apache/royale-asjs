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

goog.provide('org_apache_flex_mobile_ManagerBase');

goog.require('org_apache_flex_core_IChrome');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_utils_Language');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_mobile_ManagerBase = function() {
  org_apache_flex_mobile_ManagerBase.base(this, 'constructor');
};
goog.inherits(org_apache_flex_mobile_ManagerBase,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_mobile_ManagerBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ManagerBase',
                qName: 'org_apache_flex_mobile_ManagerBase' }] };


/**
 * @type {org_apache_flex_core_UIBase}
 */
org_apache_flex_mobile_ManagerBase.prototype._contentArea = null;


Object.defineProperties(org_apache_flex_mobile_ManagerBase.prototype, {
    /** @expose */
    contentArea: {
        /** @this {org_apache_flex_core_UIBase} */
        get: function() {
            return this._contentArea;
        },
        /** @this {org_apache_flex_core_UIBase} */
        set: function(value) {
            this._contentArea = value;
        }
    }
});


/**
 * @override
 * @param {Object} c Element being added.
 */
org_apache_flex_mobile_ManagerBase.prototype.addElement = function(c) {
  if (org_apache_flex_utils_Language.is(c, org_apache_flex_core_IChrome)) {
     org_apache_flex_mobile_ManagerBase.base(this, 'addElement', c);
  }
  else {
    this._contentArea.addElement(c);
  }
};


/**
 * @override
 * @param {Object} c The child element.
 * @param {number} index The index.
 */
org_apache_flex_mobile_ManagerBase.prototype.addElementAt =
    function(c, index) {
  if (org_apache_flex_utils_Language.is(c, org_apache_flex_core_IChrome)) {
     org_apache_flex_mobile_ManagerBase.base(this, 'addElementAt', c, index);
  }
  else {
    this._contentArea.addElementAt(c, index);
  }
};


/**
 * @override
 * @param {Object} c The child element.
 * @return {number} The index in parent.
 */
org_apache_flex_mobile_ManagerBase.prototype.getElementIndex =
    function(c) {
  return this._contentArea.getElementIndex(c);
};


/**
 * @override
 * @param {Object} c The child element.
 */
org_apache_flex_mobile_ManagerBase.prototype.removeElement =
    function(c) {
  this._contentArea.removeElement(c);
};


/**
 * @override
 */
org_apache_flex_mobile_ManagerBase.prototype.createElement =
    function() {

  this.element = document.createElement('div');
  this.element.className = 'ManagerBase';

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  this._contentArea = new org_apache_flex_core_UIBase();
  this._contentArea.className = 'ContentArea';
  org_apache_flex_core_UIBase.prototype.addElement.call(this, this._contentArea);

  return this.element;
};
