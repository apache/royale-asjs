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

goog.provide('org.apache.flex.core.ContainerBaseStrandChildren');

goog.require('org.apache.flex.core.IParent');



/**
 * @constructor
 * @implements {org.apache.flex.core.IParent}
 * @param {Object} owner The base owner of this object.
 */
org.apache.flex.core.ContainerBaseStrandChildren = function(owner) {
  this.owner_ = owner;
};


/**
 * @private
 * @type {Object}
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.owner_ = null;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ContainerBaseStrandChildren',
                qName: 'org.apache.flex.core.ContainerBaseStrandChildren'}] ,
      interfaces: [org.apache.flex.core.IParent]};


/**
 * @export
 * @return {number} The number of non-content children elements
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.numElements =
  function() {
  return this.owner_.$numElements();
};


/**
 * @export
 * @param {Object} c The element to be added.
 * @param {boolean=} opt_dispatchEvent Whether or not to dispatch an event.
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.addElement =
  function(c, opt_dispatchEvent) {
  this.owner_.$addElement(c, opt_dispatchEvent);
};


/**
 * @export
 * @param {Object} c The element to be added.
 * @param {number} index The index of the new element.
 * @param {boolean=} opt_dispatchEvent Whether or not to dispatch an event.
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.addElementAt =
  function(c, index, opt_dispatchEvent) {
  this.owner_.$addElementAt(c, index, opt_dispatchEvent);
};


/**
 * @export
 * @param {Object} c The element to be removed.
 * @param {boolean=} opt_dispatchEvent Whether or not to dispatch an event.
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.removeElement =
  function(c, opt_dispatchEvent) {
  this.owner_.$removeElement(c, opt_dispatchEvent);
};


/**
 * @export
 * @param {number} index The index of the element sought.
 * @return {Object} The element at the given index.
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.getElementAt =
  function(index) {
  return this.owner_.$getElementAt(index);
};


/**
 * @export
 * @param {Object} c The element in question.
 * @return {number} The index of the element.
 */
org.apache.flex.core.ContainerBaseStrandChildren.prototype.getElementIndex =
  function(c) {
  return this.owner_.$getElementIndex(c);
};
