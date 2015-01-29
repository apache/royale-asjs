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

goog.provide('org_apache_flex_html_Panel');

goog.require('org_apache_flex_html_Container');
goog.require('org_apache_flex_html_ControlBar');
goog.require('org_apache_flex_html_TitleBar');
goog.require('org_apache_flex_html_beads_PanelView');
goog.require('org_apache_flex_html_beads_models_PanelModel');



/**
 * @constructor
 * @extends {org_apache_flex_html_Container}
 */
org_apache_flex_html_Panel = function() {
  org_apache_flex_html_Panel.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_Panel,
    org_apache_flex_html_Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_Panel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Panel',
                qName: 'org_apache_flex_html_Panel' }] };


/**
 * @override
 * @param {Object} c Element being added.
 */
org_apache_flex_html_Panel.prototype.addElement = function(c) {
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
org_apache_flex_html_Panel.prototype.addElementAt =
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
org_apache_flex_html_Panel.prototype.getElementIndex =
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
org_apache_flex_html_Panel.prototype.removeElement =
    function(c) {
  this.contentArea.removeChild(c.element);
};


/**
 * @override
 */
org_apache_flex_html_Panel.prototype.createElement =
    function() {

  this.element = document.createElement('div');
  this.element.className = 'Panel';
  this.typeNames = 'Panel';

  this.contentArea = document.createElement('div');
  this.contentArea.flexjs_wrapper = this;
  this.element.appendChild(this.contentArea);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @override
 */
org_apache_flex_html_Panel.prototype.addedToParent =
    function() {
  org_apache_flex_html_Panel.base(this, 'addedToParent');
};


/**
 * @expose
 * @return {boolean} The showCloseButton getter.
 */
org_apache_flex_html_Panel.prototype.get_showCloseButton = function() {
  return this.model.showCloseButton;
};


/**
 * @expose
 * @param {boolean} value The showCloseButton setter.
 */
org_apache_flex_html_Panel.prototype.set_showCloseButton =
    function(value) {
  this.model.showCloseButton = value;
};


/**
 * @expose
 * @return {string} The title getter.
 */
org_apache_flex_html_Panel.prototype.get_title = function() {
  return this.model.title;
};


/**
 * @expose
 * @param {string} value The title setter.
 */
org_apache_flex_html_Panel.prototype.set_title =
function(value) {
  this.model.title = value;
};


/**
 * @expose
 * @return {Array} The controlBar getter.
 */
org_apache_flex_html_Panel.prototype.get_controlBar =
    function() {
  return this.controlBarChildren;
};


/**
 * @expose
 * @param {Array} value The controlBar setter.
 */
org_apache_flex_html_Panel.prototype.set_controlBar =
    function(value) {
  this.controlBarChildren = value;

  for (var i = 0; i < value.length; i++) {
    var item = value[i];
    this.controlBar.addElement(item);
  }
};
