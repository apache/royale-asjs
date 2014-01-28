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

goog.provide('org.apache.flex.html.staticControls.Panel');

goog.require('org.apache.flex.html.staticControls.Container');
goog.require('org.apache.flex.html.staticControls.ControlBar');
goog.require('org.apache.flex.html.staticControls.TitleBar');
goog.require('org.apache.flex.html.staticControls.beads.PanelView');
goog.require('org.apache.flex.html.staticControls.beads.models.PanelModel');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.Container}
 */
org.apache.flex.html.staticControls.Panel = function() {
  this.model =
      new org.apache.flex.html.staticControls.beads.models.PanelModel();
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.Panel,
    org.apache.flex.html.staticControls.Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.Panel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Panel',
                qName: 'org.apache.flex.html.staticControls.Panel' }] };


/**
 * @override
 * @param {Object} c Element being added.
 */
org.apache.flex.html.staticControls.Panel.prototype.addElement = function(c) {
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
org.apache.flex.html.staticControls.Panel.prototype.addElementAt =
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
org.apache.flex.html.staticControls.Panel.prototype.getElementIndex =
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
org.apache.flex.html.staticControls.Panel.prototype.removeElement =
    function(c) {
  this.contentArea.removeChild(c.element);
};


/**
 * @override
 */
org.apache.flex.html.staticControls.Panel.prototype.createElement =
    function() {

  this.element = document.createElement('div');
  this.element.className = 'Panel';

  this.contentArea = document.createElement('div');
  this.element.appendChild(this.contentArea);

  this.panelView = new org.apache.flex.html.staticControls.beads.PanelView();
  this.panelView.set_strand(this);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @override
 */
org.apache.flex.html.staticControls.Panel.prototype.addedToParent =
    function() {

};


/**
 * @expose
 * @return {string} The title getter.
 */
org.apache.flex.html.staticControls.Panel.prototype.get_title = function() {
  return this.model.get_title();
};


/**
 * @expose
 * @param {string} value The title setter.
 */
org.apache.flex.html.staticControls.Panel.prototype.set_title =
    function(value) {
  this.model.set_title(value);
};


/**
 * @expose
 * @return {Array} The controlBar getter.
 */
org.apache.flex.html.staticControls.Panel.prototype.get_controlBar =
    function() {
  return this.controlBarChildren;
};


/**
 * @expose
 * @param {Array} value The controlBar setter.
 */
org.apache.flex.html.staticControls.Panel.prototype.set_controlBar =
    function(value) {
  this.controlBarChildren = value;

  for (var i = 0; i < value.length; i++) {
    var item = value[i];
    this.controlBar.addElement(item);
  }
};
