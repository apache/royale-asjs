/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.core.UIBase');

goog.require('org.apache.flex.core.HTMLElementWrapper');
goog.require('org.apache.flex.core.IBeadController');
goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.core.IBeadModel');
goog.require('org.apache.flex.core.IBeadView');
goog.require('org.apache.flex.core.ValuesManager');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.core.UIBase = function() {
  goog.base(this);

  /**
   * @private
   * @type {string}
   */
  this.lastDisplay_ = '';

  /**
   * @protected
   * @type {Object}
   */
  this.positioner = null;

  this.createElement();
};
goog.inherits(org.apache.flex.core.UIBase,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * @return {Object} The array of children.
 */
org.apache.flex.core.UIBase.prototype.internalChildren =
    function() {
  return this.element.childNodes;
};


/**
 * @protected
 * @return {Object} The actual element to be parented.
 */
org.apache.flex.core.UIBase.prototype.createElement = function() {
  if (this.element == null)
    this.element = document.createElement('div');

  return this.element;
};


/**
 * @param {Object} c The child element.
 */
org.apache.flex.core.UIBase.prototype.addElement = function(c) {
  this.element.appendChild(c.element);
  c.addedToParent();
};


/**
 * @param {Object} c The child element.
 * @param {number} index The index.
 */
org.apache.flex.core.UIBase.prototype.addElementAt = function(c, index) {
  var children = this.internalChildren();
  if (index >= children.length)
    this.addElement(c);
  else
  {
    this.element.insertBefore(c.element,
        children[index]);
    c.addedToParent();
  }
};


/**
 * @param {Object} c The child element.
 * @return {number} The index in parent.
 */
org.apache.flex.core.UIBase.prototype.getElementIndex = function(c) {
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
 * @param {Object} c The child element.
 */
org.apache.flex.core.UIBase.prototype.removeElement = function(c) {
  this.element.removeChild(c.element);
};


/**
 */
org.apache.flex.core.UIBase.prototype.addedToParent = function() {

  var c;
  if (this.getBeadByType(org.apache.flex.core.IBeadModel) == null)
  {
    c = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this, 'iBeadModel');
    if (c)
    {
      var model = new c();
      if (model)
        this.addBead(model);
    }
  }
  if (this.getBeadByType(org.apache.flex.core.IBeadView) == null)
  {
    c = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this, 'iBeadView');
    if (c)
    {
      var view = new c();
      if (view)
        this.addBead(view);
    }
  }
  if (this.getBeadByType(org.apache.flex.core.IBeadLayout) == null)
  {
    c = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this, 'iBeadLayout');
    if (c)
    {
      var layout = new c();
      if (layout)
        this.addBead(layout);
    }
  }
  if (this.getBeadByType(org.apache.flex.core.IBeadController) == null)
  {
    c = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this, 'iBeadController');
    if (c)
    {
      var controller = new c();
      if (controller)
        this.addBead(controller);
    }
  }
};


/**
 * @param {Object} bead The bead to be added.
 */
org.apache.flex.core.UIBase.prototype.addBead = function(bead) {
  if (!this.beads_) {
    this.beads_ = new Array();
  }
  this.beads_.push(bead);

  if (bead instanceof org.apache.flex.core.IBeadModel)
    this.model = bead;

  if (bead instanceof org.apache.flex.core.IBeadView) {
    this.dispatchEvent(new org.apache.flex.events.Event('viewChanged'));
  }

  bead.set_strand(this);
};


/**
 * @param {Object} classOrInterface A type or interface.
 * @return {Object} The bead of the given type or null.
 */
org.apache.flex.core.UIBase.prototype.getBeadByType =
    function(classOrInterface) {
  if (!this.beads_) {
    this.beads_ = new Array();
  }
  for (var i = 0; i < this.beads_.length; i++) {
    var bead = this.beads_[i];
    if (bead instanceof classOrInterface) {
      return bead;
    }
  }
  return null;
};


/**
 * @param {Object} value The bead to be removed.
 * @return {Object} The bead that was removed.
 */
org.apache.flex.core.UIBase.prototype.removeBead =
    function(value) {
  if (!this.beads_) return null;
  var n = this.beads_.length;
  for (var i = 0; i < n; i++) {
    var bead = this.beads_[i];
    if (bead == value) {
      this.beads_.splice(i, 1);
      return bead;
    }
  }

  return null;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_x = function(pixels) {
  this.positioner.style.position = 'absolute';
  this.positioner.style.left = pixels.toString() + 'px';
};


/**
 * @expose
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.set_y = function(pixels) {
  this.positioner.style.position = 'absolute';
  this.positioner.style.top = pixels.toString() + 'px';
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_width = function(pixels) {
  this.positioner.style.width = pixels.toString() + 'px';
};


/**
 * @expose
 * @return {number} The width of the object in pixels.
 */
org.apache.flex.core.UIBase.prototype.get_width = function() {
  var strpixels = this.positioner.style.width;
  var pixels = parseFloat(strpixels);
  return pixels;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.set_height = function(pixels) {
  this.positioner.style.height = pixels.toString() + 'px';
};


/**
 * @expose
 * @return {number} The height of the object in pixels.
 */
org.apache.flex.core.UIBase.prototype.get_height = function() {
  var strpixels = this.positioner.style.height;
  var pixels = parseFloat(strpixels);
  return pixels;
};


/**
 * @expose
 * @type {string}
 */
org.apache.flex.core.UIBase.prototype.id = '';


/**
 * @expose
 * @return {string} The id.
 */
org.apache.flex.core.UIBase.prototype.get_id = function() {
  return this.id;
};


/**
 * @expose
 * @param {string} value The new id.
 */
org.apache.flex.core.UIBase.prototype.set_id = function(value) {
  if (this.id !== value) {
    this.element.id = value;
    this.id = value;
    this.dispatchEvent('idChanged');
  }
};


/**
 * @expose
 * @type {string}
 */
org.apache.flex.core.UIBase.prototype.className = '';


/**
 * @expose
 * @return {string} The className.
 */
org.apache.flex.core.UIBase.prototype.get_className = function() {
  return this.className;
};


/**
 * @expose
 * @param {string} value The new className.
 */
org.apache.flex.core.UIBase.prototype.set_className = function(value) {
  if (this.className !== value)
  {
    this.element.className = value;
    this.className = value;
    this.dispatchEvent('classNameChanged');
  }
};


/**
 * @expose
 * @type {Object}
 */
org.apache.flex.core.UIBase.prototype.model = null;


/**
 * @expose
 * @return {Object} The model.
 */
org.apache.flex.core.UIBase.prototype.get_model = function() {
  if (this.model == null)
  {
    // addbead will set _model
    var m = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this, 'iBeadModel');
    var b = new m;
    this.addBead(b);
  }
  return this.model;
};


/**
 * @expose
 * @param {Object} value The new model.
 */
org.apache.flex.core.UIBase.prototype.set_model = function(value) {
  if (this.model !== value) {
    this.addBead(value);
    this.dispatchEvent('modelChanged');
  }
};


/**
 * @expose
 * @return {boolean} True if visible.
 */
org.apache.flex.core.UIBase.prototype.get_visible = function() {
  return this.element.style.display !== 'none';
};


/**
 * @expose
 * @param {boolean} value The new model.
 */
org.apache.flex.core.UIBase.prototype.set_visible = function(value) {
  var oldValue = this.element.style.display !== 'none';
  if (value !== oldValue) {
    if (!value) {
      this.lastDisplay_ = this.element.style.display;
      this.element.style.display = 'none';
      this.dispatchEvent(new org.apache.flex.events.Event('hide'));
    } else {
      if (this.lastDisplay_) {
        this.element.style.display = this.lastDisplay_;
      } else {
        this.element.style.display = 'block';
      }
      this.dispatchEvent(new org.apache.flex.events.Event('show'));
    }
  }
};
