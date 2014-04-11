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

goog.provide('org.apache.flex.html.Container');

goog.require('org.apache.flex.core.ContainerBase');
goog.require('org.apache.flex.core.IContainer');



/**
 * @constructor
 * @implements {org.apache.flex.core.IContainer}
 * @extends {org.apache.flex.core.ContainerBase}
 */
org.apache.flex.html.Container = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.Container,
    org.apache.flex.core.ContainerBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.Container.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Container',
                qName: 'org.apache.flex.html.Container' }],
      interfaces: [org.apache.flex.core.IContainer] };


/**
 * @override
 */
org.apache.flex.html.Container.prototype.createElement =
    function() {
  var cb;

  this.element = document.createElement('div');

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @override
 */
org.apache.flex.html.Container.prototype.addElement =
    function(child) {
  goog.base(this, 'addElement', child);
  this.dispatchEvent('elementAdded');
};


/**
 * @expose
 */
org.apache.flex.html.Container.prototype.childrenAdded =
    function() {
  this.dispatchEvent('childrenAdded');
};


/**
 * @expose
 * @return {Array} the HTML DOM element children.
 */
org.apache.flex.html.Container.prototype.internalChildren =
    function() {
  return this.element.children;
};


/**
 * @return {Array} All of the children of the container.
 */
org.apache.flex.html.Container.prototype.getChildren = function() {
  return this.element.children;
};


/**
 * Called after all of the children have been added to the container.
 * @return {void}
 */
org.apache.flex.html.Container.prototype.childrenAdded = function() {};


