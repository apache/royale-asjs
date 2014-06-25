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

goog.provide('org.apache.flex.html.Panel');

goog.require('org.apache.flex.html.Container');
goog.require('org.apache.flex.html.ControlBar');
goog.require('org.apache.flex.html.TitleBar');
goog.require('org.apache.flex.html.beads.PanelView');
goog.require('org.apache.flex.html.beads.models.PanelModel');



/**
 * @constructor
 * @extends {org.apache.flex.html.Container}
 */
org.apache.flex.html.Panel = function() {
  this.model =
      new org.apache.flex.html.beads.models.PanelModel();
  org.apache.flex.html.Panel.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.Panel,
    org.apache.flex.html.Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.Panel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Panel',
                qName: 'org.apache.flex.html.Panel' }] };


/**
 * @override
 * @param {Object} c Element being added.
 */
org.apache.flex.html.Panel.prototype.addElement = function(c) {
  if (c == this.titleBar) {
    this.element.insertBefore(this.titleBar.element, this.contentArea);
  }
  else if (c == this.controlBar) {
    this.element.appendChild(c.element);
  }
  else {
    this.contentArea.appendChild(c.element);
  }
  c.addedToParent();
};


/**
 * @override
 * @param {Object} c The child element.
 * @param {number} index The index.
 */
org.apache.flex.html.Panel.prototype.addElementAt =
    function(c, index) {
  var children = this.internalChildren();
  if (index >= children.length)
    this.addElement(c);
  else
  {
    this.contentArea.insertBefore(c.element,
        children[index]);
    c.addedToParent();
  }
};


/**
 * @override
 * @param {Object} c The child element.
 * @return {number} The index in parent.
 */
org.apache.flex.html.Panel.prototype.getElementIndex =
    function(c) {
  var children = this.internalChildren();
  var n = children.length;
  for (var i = 0; i < n; i++)
  {
    if (children[i] == c.element)
      return i;
  }
  return -1;
};


/**
 * @override
 * @param {Object} c The child element.
 */
org.apache.flex.html.Panel.prototype.removeElement =
    function(c) {
  this.contentArea.removeChild(c.element);
};


/**
 * @override
 */
org.apache.flex.html.Panel.prototype.createElement =
    function() {

  this.element = document.createElement('div');
  this.element.className = 'Panel';

  this.contentArea = document.createElement('div');
  this.contentArea.flexjs_wrapper = this;
  this.element.appendChild(this.contentArea);

  this.panelView = new org.apache.flex.html.beads.PanelView();
  this.panelView.set_strand(this);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @override
 */
org.apache.flex.html.Panel.prototype.addedToParent =
    function() {
  org.apache.flex.html.Panel.base(this, 'addedToParent');
};


/**
 * @expose
 * @return {string} The title getter.
 */
org.apache.flex.html.Panel.prototype.get_title = function() {
  return this.model.get_title();
};


/**
 * @expose
 * @param {string} value The title setter.
 */
org.apache.flex.html.Panel.prototype.set_title =
    function(value) {
  this.model.set_title(value);
};


/**
 * @expose
 * @return {Array} The controlBar getter.
 */
org.apache.flex.html.Panel.prototype.get_controlBar =
    function() {
  return this.controlBarChildren;
};


/**
 * @expose
 * @param {Array} value The controlBar setter.
 */
org.apache.flex.html.Panel.prototype.set_controlBar =
    function(value) {
  this.controlBarChildren = value;

  for (var i = 0; i < value.length; i++) {
    var item = value[i];
    this.controlBar.addElement(item);
  }
};
