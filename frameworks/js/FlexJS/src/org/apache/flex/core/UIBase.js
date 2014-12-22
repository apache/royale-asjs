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
goog.require('org.apache.flex.core.ILayoutChild');
goog.require('org.apache.flex.core.IParentIUIBase');
goog.require('org.apache.flex.core.IStyleableObject');
goog.require('org.apache.flex.core.IUIBase');
goog.require('org.apache.flex.core.ValuesManager');



/**
 * @constructor
 * @implements {org.apache.flex.core.IUIBase}
 * @implements {org.apache.flex.core.ILayoutChild}
 * @implements {org.apache.flex.core.IParentIUIBase}
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.core.UIBase = function() {
  org.apache.flex.core.UIBase.base(this, 'constructor');

  /**
   * @private
   * @type {string}
   */
  this.lastDisplay_ = '';

  /**
   * @private
   * @type {number}
   */
  this.explicitWidth_ = NaN;

  /**
   * @private
   * @type {number}
   */
  this.explicitHeight_ = NaN;


  /**
   * @private
   * @type {number}
   */
  this.percentWidth_ = NaN;


  /**
   * @private
   * @type {number}
   */
  this.percentHeight_ = NaN;

  /**
   * @private
   * @type {Array.<Object>}
   */
  this.mxmlBeads_ = null;

  /**
   * @private
   * @type {Object}
   */
  this.style_ = null;

  this.createElement();
};
goog.inherits(org.apache.flex.core.UIBase,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.UIBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIBase',
                qName: 'org.apache.flex.core.UIBase' }],
      interfaces: [org.apache.flex.core.IUIBase,
                   org.apache.flex.core.IParentIUIBase,
                   org.apache.flex.core.ILayoutChild,
                   org.apache.flex.core.IStyleableObject] };


/**
 * @expose
 * @param {Array.<Object>} value The list of beads from MXML.
 */
org.apache.flex.core.UIBase.prototype.set_beads = function(value) {
  this.mxmlBeads_ = value;
};


/**
 * @expose
 * @type {Object}
 */
org.apache.flex.core.UIBase.prototype.positioner = null;


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
  if (this.positioner == null)
    this.positioner = this.element;
  this.positioner.style.display = 'block';

  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @protected
 * @type {?function()}
 */
org.apache.flex.core.UIBase.prototype.finalizeElement = null;


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
 * @param {number} index The index in parent.
 * @return {Object} The child element.
 */
org.apache.flex.core.UIBase.prototype.getElementAt = function(index) {
  var children = this.internalChildren();
  return children[index].flexjs_wrapper;
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
 * @return {number} The number of child elements.
 */
org.apache.flex.core.UIBase.prototype.get_numElements = function() {
  var children = this.internalChildren();
  return children.length;
};


/**
 * @return {Object} The parent of this object.
 */
org.apache.flex.core.UIBase.prototype.get_parent = function() {
  var p = this.element.parentNode;
  var wrapper = p.flexjs_wrapper;
  return wrapper;
};


/**
 */
org.apache.flex.core.UIBase.prototype.addedToParent = function() {

  var styles = this.get_style();
  if (styles)
    org.apache.flex.core.ValuesManager.valuesImpl.applyStyles(this, styles);

  if (this.mxmlBeads_) {
    var n = this.mxmlBeads_.length;
    for (var i = 0; i < n; i++) {
      this.addBead(this.mxmlBeads_[i]);
    }
  }

  /**
   * @type {Function}
   */
  var c;
  if (this.getBeadByType(org.apache.flex.core.IBeadModel) == null)
  {
    if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org.apache.flex.core.ValuesManager.valuesImpl.
          getValue(this, 'iBeadModel'));
      if (c)
      {
        var model = new c();
        if (model)
          this.addBead(model);
      }
    }
  }
  if (this.getBeadByType(org.apache.flex.core.IBeadView) == null)
  {
    if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org.apache.flex.core.ValuesManager.valuesImpl.
          getValue(this, 'iBeadView'));
      if (c)
      {
        var view = new c();
        if (view)
          this.addBead(view);
      }
    }
  }
  if (this.getBeadByType(org.apache.flex.core.IBeadLayout) == null)
  {
    if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org.apache.flex.core.ValuesManager.valuesImpl.
          getValue(this, 'iBeadLayout'));
      if (c)
      {
        var layout = new c();
        if (layout)
          this.addBead(layout);
      }
    }
  }
  if (this.getBeadByType(org.apache.flex.core.IBeadController) == null)
  {
    if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org.apache.flex.core.ValuesManager.valuesImpl.
          getValue(this, 'iBeadController'));
      if (c)
      {
        var controller = new c();
        if (controller)
          this.addBead(controller);
      }
    }
  }
};


/**
 * @param {Object} bead The bead to be added.
 */
org.apache.flex.core.UIBase.prototype.addBead = function(bead) {
  if (!this.beads_) {
    this.beads_ = [];
  }
  this.beads_.push(bead);

  if (org.apache.flex.utils.Language.is(bead, org.apache.flex.core.IBeadModel))
    this.model = bead;

  if (org.apache.flex.utils.Language.is(bead, org.apache.flex.core.IBeadView)) {
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
    this.beads_ = [];
  }
  for (var i = 0; i < this.beads_.length; i++) {
    var bead = this.beads_[i];
    if (org.apache.flex.utils.Language.is(bead, classOrInterface)) {
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
 * @param {number} alpha The alpha or opacity.
 */
org.apache.flex.core.UIBase.prototype.set_alpha = function(alpha) {
  this.positioner.style.opacity = alpha;
};


/**
 * @expose
 * @return {number} The alpha or opacity.
 */
org.apache.flex.core.UIBase.prototype.get_alpha = function() {
  var stralpha = this.positioner.style.opacity;
  var alpha = parseFloat(stralpha);
  return alpha;
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
 * @return {number} The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.get_x = function() {
  var strpixels = this.positioner.style.left;
  var pixels = parseFloat(strpixels);
  if (isNaN(pixels))
    pixels = this.positioner.offsetLeft;
  return pixels;
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
 * @return {number} The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.get_y = function() {
  var strpixels = this.positioner.style.top;
  var pixels = parseFloat(strpixels);
  if (isNaN(pixels))
    pixels = this.positioner.offsetTop;
  return pixels;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_width = function(pixels) {
  this.set_explicitWidth(pixels);
  this.setWidth(pixels);
};


/**
 * @expose
 * @return {number} The width of the object in pixels.
 */
org.apache.flex.core.UIBase.prototype.get_width = function() {
  var pixels;
  var strpixels = this.positioner.style.width;
  pixels = parseFloat(strpixels);
  if (isNaN(pixels))
    pixels = this.positioner.offsetWidth;
  return pixels;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_explicitWidth = function(pixels) {
  this.explicitWidth_ = pixels;
  if (!isNaN(pixels))
    this.percentWidth_ = NaN;
};


/**
 * @expose
 * @return {number} The width of the object in pixels.
 */
org.apache.flex.core.UIBase.prototype.get_explicitWidth = function() {
  return this.explicitWidth_;
};


/**
 * @expose
 * @param {number} pixels The percent width of the object.
 */
org.apache.flex.core.UIBase.prototype.set_percentWidth = function(pixels) {
  this.percentWidth_ = pixels;
  this.positioner.style.width = pixels.toString() + '%';
  if (!isNaN(pixels))
    this.explicitWidth_ = NaN;
};


/**
 * @expose
 * @return {number} The percent width of the object.
 */
org.apache.flex.core.UIBase.prototype.get_percentWidth = function() {
  return this.percentWidth_;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.set_height = function(pixels) {
  this.set_explicitHeight(pixels);
  this.setHeight(pixels);
};


/**
 * @expose
 * @return {number} The height of the object in pixels.
 */
org.apache.flex.core.UIBase.prototype.get_height = function() {
  var pixels;
  var strpixels = this.positioner.style.height;
  pixels = parseFloat(strpixels);
  if (isNaN(pixels))
    pixels = this.positioner.offsetHeight;
  return pixels;
};


/**
 * @expose
 * @param {number} pixels The height of the object in pixels.
 */
org.apache.flex.core.UIBase.prototype.set_explicitHeight = function(pixels) {
  this.explicitHeight_ = pixels;
  if (!isNaN(pixels))
    this.percentHeight_ = NaN;
};


/**
 * @expose
 * @return {number} The height of the object in pixels.
 */
org.apache.flex.core.UIBase.prototype.get_explicitHeight = function() {
  return this.explicitHeight_;
};


/**
 * @expose
 * @param {number} pixels The percentage height.
 */
org.apache.flex.core.UIBase.prototype.set_percentHeight = function(pixels) {
  this.percentHeight_ = pixels;
  this.positioner.style.height = pixels.toString() + '%';
  if (!isNaN(pixels))
    this.explicitHeight_ = NaN;
};


/**
 * @expose
 * @return {number} The percentage height of the object.
 */
org.apache.flex.core.UIBase.prototype.get_percentHeight = function() {
  return this.percentHeight_;
};


/**
 * @expose
 * @param {number} value The height of the object in pixels.
 * @param {boolean=} opt_noEvent Whether to skip sending a change event.
 */
org.apache.flex.core.UIBase.prototype.setHeight =
    function(value, opt_noEvent)
{
  if (opt_noEvent === undefined)
    opt_noEvent = false;

  var _height = this.get_height();
  if (_height != value) {
    this.positioner.style.height = value.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('heightChanged');
  }
};


/**
 * @expose
 * @param {number} value The width of the object in pixels.
 * @param {boolean=} opt_noEvent Whether to skip sending a change event.
 */
org.apache.flex.core.UIBase.prototype.setWidth =
    function(value, opt_noEvent)
{
  if (opt_noEvent === undefined)
    opt_noEvent = false;

  var _width = this.get_width();
  if (_width != value) {
    this.positioner.style.width = value.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('widthChanged');
  }
};


/**
 * @expose
 * @param {number} newWidth The width of the object in pixels.
 * @param {number} newHeight The height of the object in pixels.
 * @param {boolean=} opt_noEvent Whether to skip sending a change event.
 */
org.apache.flex.core.UIBase.prototype.setWidthAndHeight =
    function(newWidth, newHeight, opt_noEvent)
{
  if (opt_noEvent === undefined)
    opt_noEvent = false;

  var _width = this.get_width();
  if (_width != newWidth) {
    this.positioner.style.width = newWidth.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('widthChanged');
  }
  var _height = this.get_height();
  if (_height != newHeight) {
    this.positioner.style.height = newHeight.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('heightChanged');
  }
  this.dispatchEvent('sizeChanged');
};


/**
 * @expose
 * @return {boolean} True if width sized to content.
 */
org.apache.flex.core.UIBase.prototype.isWidthSizedToContent = function()
{
  return (isNaN(this.explicitWidth_) && isNaN(this.percentWidth_));
};


/**
 * @expose
 * @return {boolean} True if height sized to content.
 */
org.apache.flex.core.UIBase.prototype.isHeightSizedToContent = function()
{
  return (isNaN(this.explicitHeight_) && isNaN(this.percentHeight_));
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
org.apache.flex.core.UIBase.prototype.typeNames = '';


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
    this.element.className = this.typeNames ? value + ' ' + this.typeNames : value;
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
    if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
      /**
       * @type {Function}
       */
      var m = /** @type {Function} */ (org.apache.flex.core.ValuesManager.valuesImpl.
          getValue(this, 'iBeadModel'));
      var b = new m();
      this.addBead(b);
    }
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
 * @return {Object} The style properties.
 */
org.apache.flex.core.UIBase.prototype.get_style = function() {
  return this.style_;
};


/**
 * @expose
 * @param {Object} value The new style properties.
 */
org.apache.flex.core.UIBase.prototype.set_style = function(value) {
  if (this.style_ !== value) {
    if (typeof(value) == 'string')
      value = org.apache.flex.core.ValuesManager.valuesImpl.parseStyles(value);
    this.style_ = value;
    this.dispatchEvent('stylesChanged');
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
