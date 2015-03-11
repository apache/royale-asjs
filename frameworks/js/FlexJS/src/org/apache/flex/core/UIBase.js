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

goog.provide('org_apache_flex_core_UIBase');

goog.require('org_apache_flex_core_HTMLElementWrapper');
goog.require('org_apache_flex_core_IBeadController');
goog.require('org_apache_flex_core_IBeadLayout');
goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_core_IBeadView');
goog.require('org_apache_flex_core_ILayoutChild');
goog.require('org_apache_flex_core_IParentIUIBase');
goog.require('org_apache_flex_core_IStyleableObject');
goog.require('org_apache_flex_core_IUIBase');
goog.require('org_apache_flex_core_ValuesManager');
goog.require('org_apache_flex_events_ValueChangeEvent');



/**
 * @constructor
 * @implements {org_apache_flex_core_IUIBase}
 * @implements {org_apache_flex_core_ILayoutChild}
 * @implements {org_apache_flex_core_IParentIUIBase}
 * @extends {org_apache_flex_core_HTMLElementWrapper}
 */
org_apache_flex_core_UIBase = function() {
  org_apache_flex_core_UIBase.base(this, 'constructor');

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
goog.inherits(org_apache_flex_core_UIBase,
    org_apache_flex_core_HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_UIBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIBase',
                qName: 'org_apache_flex_core_UIBase' }],
      interfaces: [org_apache_flex_core_IUIBase,
                   org_apache_flex_core_IParentIUIBase,
                   org_apache_flex_core_ILayoutChild,
                   org_apache_flex_core_IStyleableObject] };


/**
 * @expose
 * @param {Array.<Object>} value The list of beads from MXML.
 */
org_apache_flex_core_UIBase.prototype.set_beads = function(value) {
  this.mxmlBeads_ = value;
};


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_core_UIBase.prototype.positioner = null;


/**
 * @return {Object} The array of children.
 */
org_apache_flex_core_UIBase.prototype.internalChildren =
    function() {
  return this.element.childNodes;
};


/**
 * @protected
 * @return {Object} The actual element to be parented.
 */
org_apache_flex_core_UIBase.prototype.createElement = function() {
  if (this.element == null)
    this.element = document.createElement('div');
  if (this.positioner == null)
    this.positioner = this.element;
  this.positioner.style.display = 'block';

  this.element.flexjs_wrapper = this;

  return this.positioner;
};


/**
 * @protected
 * @type {?function()}
 */
org_apache_flex_core_UIBase.prototype.finalizeElement = null;


/**
 * @param {Object} c The child element.
 */
org_apache_flex_core_UIBase.prototype.addElement = function(c) {
  this.element.appendChild(c.positioner);
  c.addedToParent();
};


/**
 * @param {Object} c The child element.
 * @param {number} index The index.
 */
org_apache_flex_core_UIBase.prototype.addElementAt = function(c, index) {
  var children = this.internalChildren();
  if (index >= children.length)
    this.addElement(c);
  else
  {
    this.element.insertBefore(c.positioner,
        children[index]);
    c.addedToParent();
  }
};


/**
 * @param {number} index The index in parent.
 * @return {Object} The child element.
 */
org_apache_flex_core_UIBase.prototype.getElementAt = function(index) {
  var children = this.internalChildren();
  return children[index].flexjs_wrapper;
};


/**
 * @param {Object} c The child element.
 * @return {number} The index in parent.
 */
org_apache_flex_core_UIBase.prototype.getElementIndex = function(c) {
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
org_apache_flex_core_UIBase.prototype.removeElement = function(c) {
  this.element.removeChild(c.element);
};


/**
 * @return {number} The number of child elements.
 */
org_apache_flex_core_UIBase.prototype.get_numElements = function() {
  var children = this.internalChildren();
  return children.length;
};


/**
 * @return {Object} The parent of this object.
 */
org_apache_flex_core_UIBase.prototype.get_parent = function() {
  var p = this.positioner.parentNode;
  var wrapper = p.flexjs_wrapper;
  return wrapper;
};


/**
 */
org_apache_flex_core_UIBase.prototype.addedToParent = function() {

  var styles = this.get_style();
  if (styles)
    org_apache_flex_core_ValuesManager.valuesImpl.applyStyles(this, styles);

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
  if (this.getBeadByType(org_apache_flex_core_IBeadModel) == null)
  {
    if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
          getValue(this, 'iBeadModel'));
      if (c)
      {
        var model = new c();
        if (model)
          this.addBead(model);
      }
    }
  }
  if (this.getBeadByType(org_apache_flex_core_IBeadView) == null)
  {
    if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
          getValue(this, 'iBeadView'));
      if (c)
      {
        var view = new c();
        if (view)
          this.addBead(view);
      }
    }
  }
  if (this.getBeadByType(org_apache_flex_core_IBeadLayout) == null)
  {
    if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
          getValue(this, 'iBeadLayout'));
      if (c)
      {
        var layout = new c();
        if (layout)
          this.addBead(layout);
      }
    }
  }
  if (this.getBeadByType(org_apache_flex_core_IBeadController) == null)
  {
    if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
      c = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
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
org_apache_flex_core_UIBase.prototype.addBead = function(bead) {
  if (!this.beads_) {
    this.beads_ = [];
  }
  this.beads_.push(bead);

  if (org_apache_flex_utils_Language.is(bead, org_apache_flex_core_IBeadModel))
    this.model = bead;

  if (org_apache_flex_utils_Language.is(bead, org_apache_flex_core_IBeadView)) {
    this.dispatchEvent(new org_apache_flex_events_Event('viewChanged'));
  }

  bead.set_strand(this);
};


/**
 * @param {Object} classOrInterface A type or interface.
 * @return {Object} The bead of the given type or null.
 */
org_apache_flex_core_UIBase.prototype.getBeadByType =
    function(classOrInterface) {
  if (!this.beads_) {
    this.beads_ = [];
  }
  for (var i = 0; i < this.beads_.length; i++) {
    var bead = this.beads_[i];
    if (org_apache_flex_utils_Language.is(bead, classOrInterface)) {
      return bead;
    }
  }
  return null;
};


/**
 * @param {Object} value The bead to be removed.
 * @return {Object} The bead that was removed.
 */
org_apache_flex_core_UIBase.prototype.removeBead =
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
org_apache_flex_core_UIBase.prototype.set_alpha = function(alpha) {
  this.positioner.style.opacity = alpha;
};


/**
 * @expose
 * @return {number} The alpha or opacity.
 */
org_apache_flex_core_UIBase.prototype.get_alpha = function() {
  var stralpha = this.positioner.style.opacity;
  var alpha = parseFloat(stralpha);
  return alpha;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org_apache_flex_core_UIBase.prototype.set_x = function(pixels) {
  this.positioner.style.position = 'absolute';
  this.positioner.style.left = pixels.toString() + 'px';
};


/**
 * @expose
 * @return {number} The pixel count from the left edge.
 */
org_apache_flex_core_UIBase.prototype.get_x = function() {
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
org_apache_flex_core_UIBase.prototype.set_y = function(pixels) {
  this.positioner.style.position = 'absolute';
  this.positioner.style.top = pixels.toString() + 'px';
};


/**
 * @expose
 * @return {number} The pixel count from the top edge.
 */
org_apache_flex_core_UIBase.prototype.get_y = function() {
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
org_apache_flex_core_UIBase.prototype.set_width = function(pixels) {
  this.set_explicitWidth(pixels);
  this.setWidth(pixels);
};


/**
 * @expose
 * @return {number} The width of the object in pixels.
 */
org_apache_flex_core_UIBase.prototype.get_width = function() {
  var pixels;
  var strpixels = this.positioner.style.width;
  if (strpixels !== null && strpixels.indexOf('%') != -1)
    pixels = NaN;
  else
    pixels = parseFloat(strpixels);
  if (isNaN(pixels)) {
    pixels = this.positioner.offsetWidth;
    if (pixels === 0 && this.positioner.scrollWidth !== 0) {
      // invisible child elements cause offsetWidth to be 0.
      pixels = this.positioner.scrollWidth;
    }
  }
  return pixels;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org_apache_flex_core_UIBase.prototype.set_explicitWidth = function(pixels) {
  this.explicitWidth_ = pixels;
  if (!isNaN(pixels))
    this.percentWidth_ = NaN;
};


/**
 * @expose
 * @return {number} The width of the object in pixels.
 */
org_apache_flex_core_UIBase.prototype.get_explicitWidth = function() {
  return this.explicitWidth_;
};


/**
 * @expose
 * @param {number} pixels The percent width of the object.
 */
org_apache_flex_core_UIBase.prototype.set_percentWidth = function(pixels) {
  this.percentWidth_ = pixels;
  this.positioner.style.width = pixels.toString() + '%';
  if (!isNaN(pixels))
    this.explicitWidth_ = NaN;
};


/**
 * @expose
 * @return {number} The percent width of the object.
 */
org_apache_flex_core_UIBase.prototype.get_percentWidth = function() {
  return this.percentWidth_;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the top edge.
 */
org_apache_flex_core_UIBase.prototype.set_height = function(pixels) {
  this.set_explicitHeight(pixels);
  this.setHeight(pixels);
};


/**
 * @expose
 * @return {number} The height of the object in pixels.
 */
org_apache_flex_core_UIBase.prototype.get_height = function() {
  var pixels;
  var strpixels = this.positioner.style.height;
  if (strpixels !== null && strpixels.indexOf('%') != -1)
    pixels = NaN;
  else
    pixels = parseFloat(strpixels);
  if (isNaN(pixels)) {
    pixels = this.positioner.offsetHeight;
    if (pixels === 0 && this.positioner.scrollHeight !== 0) {
      // invisible child elements cause offsetHeight to be 0.
      pixels = this.positioner.scrollHeight;
    }
  }
  return pixels;
};


/**
 * @expose
 * @param {number} pixels The height of the object in pixels.
 */
org_apache_flex_core_UIBase.prototype.set_explicitHeight = function(pixels) {
  this.explicitHeight_ = pixels;
  if (!isNaN(pixels))
    this.percentHeight_ = NaN;
};


/**
 * @expose
 * @return {number} The height of the object in pixels.
 */
org_apache_flex_core_UIBase.prototype.get_explicitHeight = function() {
  return this.explicitHeight_;
};


/**
 * @expose
 * @param {number} pixels The percentage height.
 */
org_apache_flex_core_UIBase.prototype.set_percentHeight = function(pixels) {
  this.percentHeight_ = pixels;
  this.positioner.style.height = pixels.toString() + '%';
  if (!isNaN(pixels))
    this.explicitHeight_ = NaN;
};


/**
 * @expose
 * @return {number} The percentage height of the object.
 */
org_apache_flex_core_UIBase.prototype.get_percentHeight = function() {
  return this.percentHeight_;
};


/**
 * @expose
 * @param {number} value The height of the object in pixels.
 * @param {boolean=} opt_noEvent Whether to skip sending a change event.
 */
org_apache_flex_core_UIBase.prototype.setHeight =
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
org_apache_flex_core_UIBase.prototype.setWidth =
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
org_apache_flex_core_UIBase.prototype.setWidthAndHeight =
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
org_apache_flex_core_UIBase.prototype.isWidthSizedToContent = function()
{
  return (isNaN(this.explicitWidth_) && isNaN(this.percentWidth_));
};


/**
 * @expose
 * @return {boolean} True if height sized to content.
 */
org_apache_flex_core_UIBase.prototype.isHeightSizedToContent = function()
{
  return (isNaN(this.explicitHeight_) && isNaN(this.percentHeight_));
};


/**
 * @expose
 * @type {string}
 */
org_apache_flex_core_UIBase.prototype.id = '';


/**
 * @expose
 * @return {string} The id.
 */
org_apache_flex_core_UIBase.prototype.get_id = function() {
  return this.id;
};


/**
 * @expose
 * @param {string} value The new id.
 */
org_apache_flex_core_UIBase.prototype.set_id = function(value) {
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
org_apache_flex_core_UIBase.prototype.typeNames = '';


/**
 * @expose
 * @type {string}
 */
org_apache_flex_core_UIBase.prototype.className = '';


/**
 * @expose
 * @return {string} The className.
 */
org_apache_flex_core_UIBase.prototype.get_className = function() {
  return this.className;
};


/**
 * @expose
 * @param {string} value The new className.
 */
org_apache_flex_core_UIBase.prototype.set_className = function(value) {
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
org_apache_flex_core_UIBase.prototype.model = null;


/**
 * @expose
 * @return {Object} The model.
 */
org_apache_flex_core_UIBase.prototype.get_model = function() {
  if (this.model == null)
  {
    // addbead will set _model
    if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
      /**
       * @type {Function}
       */
      var m = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
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
org_apache_flex_core_UIBase.prototype.set_model = function(value) {
  if (this.model !== value) {
    this.addBead(value);
    this.dispatchEvent('modelChanged');
  }
};


/**
 * @expose
 * @return {Object} The style properties.
 */
org_apache_flex_core_UIBase.prototype.get_style = function() {
  return this.style_;
};


/**
 * @expose
 * @param {Object} value The new style properties.
 */
org_apache_flex_core_UIBase.prototype.set_style = function(value) {
  if (this.style_ !== value) {
    if (typeof(value) == 'string')
      value = org_apache_flex_core_ValuesManager.valuesImpl.parseStyles(value);
    this.style_ = value;
    if (value.addEventListener)
      value.addEventListener(org_apache_flex_events_ValueChangeEvent.VALUE_CHANGE,
          goog.bind(this.styleChangeHandler, this));
    this.dispatchEvent('stylesChanged');
  }
};


/**
 * @expose
 * @param {org_apache_flex_events_ValueChangeEvent} value The new style properties.
 */
org_apache_flex_core_UIBase.prototype.styleChangeHandler = function(value) {
  var newStyle = {};
  newStyle[value.propertyName] = value.newValue;
  org_apache_flex_core_ValuesManager.valuesImpl.applyStyles(this, newStyle);
};


/**
 * @expose
 * @return {boolean} True if visible.
 */
org_apache_flex_core_UIBase.prototype.get_visible = function() {
  return this.positioner.style.display !== 'none';
};


/**
 * @expose
 * @param {boolean} value The new model.
 */
org_apache_flex_core_UIBase.prototype.set_visible = function(value) {
  var oldValue = this.positioner.style.display !== 'none';
  if (value !== oldValue) {
    if (!value) {
      this.lastDisplay_ = this.positioner.style.display;
      this.positioner.style.display = 'none';
      this.dispatchEvent(new org_apache_flex_events_Event('hide'));
    } else {
      if (this.lastDisplay_) {
        this.positioner.style.display = this.lastDisplay_;
      } else {
        this.positioner.style.display = this.positioner.internalDisplay;
      }
      this.dispatchEvent(new org_apache_flex_events_Event('show'));
    }
  }
};


/**
 * @expose
 * @return {Object} The top most EventDispatcher.
 */
org_apache_flex_core_UIBase.prototype.get_topMostEventDispatcher = function() {
  return document.body.flexjs_wrapper;
};
