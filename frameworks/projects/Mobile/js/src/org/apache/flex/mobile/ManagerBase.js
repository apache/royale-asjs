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

goog.provide('org.apache.flex.mobile.ManagerBase');

goog.require('org.apache.flex.core.IChrome');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.mobile.ManagerBase = function() {
  org.apache.flex.mobile.ManagerBase.base(this, 'constructor');
};
goog.inherits(org.apache.flex.mobile.ManagerBase,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.mobile.ManagerBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ManagerBase',
                qName: 'org.apache.flex.mobile.ManagerBase' }] };


/**
 * @type {org.apache.flex.core.UIBase}
 */
org.apache.flex.mobile.ManagerBase.prototype._contentArea = null;


Object.defineProperties(org.apache.flex.mobile.ManagerBase.prototype, {
    /** @export */
    contentArea: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this._contentArea;
        },
        /** @this {org.apache.flex.core.UIBase} */
        set: function(value) {
            this._contentArea = value;
        }
    }
});


/**
 * @override
 * @param {Object} c Element being added.
 */
org.apache.flex.mobile.ManagerBase.prototype.addElement = function(c) {
  if (org.apache.flex.utils.Language.is(c, org.apache.flex.core.IChrome)) {
     org.apache.flex.mobile.ManagerBase.base(this, 'addElement', c);
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
org.apache.flex.mobile.ManagerBase.prototype.addElementAt =
    function(c, index) {
  if (org.apache.flex.utils.Language.is(c, org.apache.flex.core.IChrome)) {
     org.apache.flex.mobile.ManagerBase.base(this, 'addElementAt', c, index);
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
org.apache.flex.mobile.ManagerBase.prototype.getElementIndex =
    function(c) {
  return this._contentArea.getElementIndex(c);
};


/**
 * @override
 * @param {Object} c The child element.
 */
org.apache.flex.mobile.ManagerBase.prototype.removeElement =
    function(c) {
  this._contentArea.removeElement(c);
};


/**
 * @override
 */
org.apache.flex.mobile.ManagerBase.prototype.createElement =
    function() {

  this.element = document.createElement('div');
  this.element.className = 'ManagerBase';

  this.positioner = this.element;
  this.positioner.style.position = 'relative';
  this.element.flexjs_wrapper = this;

  this._contentArea = new org.apache.flex.core.UIBase();
  this._contentArea.className = 'ContentArea';
  this._contentArea.positioner.style['width'] = '100%';
  this._contentArea.positioner.style['height'] = '100%';
  org.apache.flex.core.UIBase.prototype.addElement.call(this, this._contentArea);

  return this.element;
};
