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
goog.require('org.apache.flex.events.ValueChangeEvent');



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

  /**
   * @private
   * @type {?string}
   */
  this.id_ = null;

  /**
   * @private
   * @type {?string}
   */
  this.className_ = '';

  /**
   * @private
   * @type {Object}
   */
  this.model_ = null;

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
 * @export
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
  this.positioner.style.position = 'relative';

  this.element.flexjs_wrapper = this;

  return this.positioner;
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
  this.element.appendChild(c.positioner);
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
    this.element.insertBefore(c.positioner,
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
 */
org.apache.flex.core.UIBase.prototype.addedToParent = function() {

  var styles = this.style;
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
  if (!this._beads) {
    this._beads = [];
  }
  this._beads.push(bead);

  if (org.apache.flex.utils.Language.is(bead, org.apache.flex.core.IBeadModel))
    this.model_ = bead;

  if (org.apache.flex.utils.Language.is(bead, org.apache.flex.core.IBeadView)) {
    this.dispatchEvent(new org.apache.flex.events.Event('viewChanged'));
  }

  bead.strand = this;
};


/**
 * @param {Object} classOrInterface A type or interface.
 * @return {Object} The bead of the given type or null.
 */
org.apache.flex.core.UIBase.prototype.getBeadByType =
    function(classOrInterface) {
  if (!this._beads) {
    this._beads = [];
  }
  for (var i = 0; i < this._beads.length; i++) {
    var bead = this._beads[i];
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
  if (!this._beads) return null;
  var n = this._beads.length;
  for (var i = 0; i < n; i++) {
    var bead = this._beads[i];
    if (bead == value) {
      this._beads.splice(i, 1);
      return bead;
    }
  }

  return null;
};


Object.defineProperties(org.apache.flex.core.UIBase.prototype, {
    /** @export */
    beads: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(value) {
            this.mxmlBeads_ = value;
        }
    },
    /** @export */
    numElements: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            var children = this.internalChildren();
            return children.length;
        }
    },
    /** @export */
    parent: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            var p = this.positioner.parentNode;
            var wrapper = p.flexjs_wrapper;
            return wrapper;
        }
    },
    /** @export */
    alpha: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(alpha) {
            this.positioner.style.opacity = alpha;
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            var stralpha = this.positioner.style.opacity;
            var alpha = parseFloat(stralpha);
            return alpha;
        }
    },
    /** @export */
    x: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.positioner.style.position = 'absolute';
            this.positioner.style.left = pixels.toString() + 'px';
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            var strpixels = this.positioner.style.left;
            var pixels = parseFloat(strpixels);
            if (isNaN(pixels))
              pixels = this.positioner.offsetLeft;
            return pixels;
        }
    },
    /** @export */
    y: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.positioner.style.position = 'absolute';
            this.positioner.style.top = pixels.toString() + 'px';
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            var strpixels = this.positioner.style.top;
            var pixels = parseFloat(strpixels);
            if (isNaN(pixels))
              pixels = this.positioner.offsetTop;
            return pixels;
        }
    },
    /** @export */
    clientWidth: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.positioner.clientWidth;
        }
    },
    /** @export */
    CSSWidth: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            var pixels;
            var strpixels = this.positioner.style.width;
            if (strpixels !== null && strpixels.indexOf('%') != -1)
              pixels = NaN;
            else
              pixels = parseFloat(strpixels);
            return pixels;
        }
    },
    /** @export */
    width: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.explicitWidth = pixels;
            this.setWidth(pixels);
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
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
        }
    },
    /** @export */
    explicitWidth: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.explicitWidth_ = pixels;
            if (!isNaN(pixels))
              this.percentWidth_ = NaN;
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.explicitWidth_;
        }
    },
    /** @export */
    percentWidth: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.percentWidth_ = pixels;
            this.positioner.style.width = pixels.toString() + '%';
            if (!isNaN(pixels))
              this.explicitWidth_ = NaN;
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.percentWidth_;
        }
    },
    /** @export */
    clientHeight: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.positioner.clientHeight;
        }
    },
    /** @export */
    CSSHeight: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            var pixels;
            var strpixels = this.positioner.style.height;
            if (strpixels !== null && strpixels.indexOf('%') != -1)
              pixels = NaN;
            else
              pixels = parseFloat(strpixels);
            return pixels;
        }
    },
    /** @export */
    height: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.explicitHeight = pixels;
            this.setHeight(pixels);
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
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
        }
    },
    /** @export */
    explicitHeight: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.explicitHeight_ = pixels;
            if (!isNaN(pixels))
                this.percentHeight_ = NaN;
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.explicitHeight_;
        }
    },
    /** @export */
    percentHeight: {
        /** @this {org.apache.flex.core.UIBase} */
        set: function(pixels) {
            this.percentHeight_ = pixels;
            this.positioner.style.height = pixels.toString() + '%';
            if (!isNaN(pixels))
              this.explicitHeight_ = NaN;
        },
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.percentHeight_;
        }
    },
    /** @export */
    id: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.id_;
        },
        /** @this {org.apache.flex.core.UIBase} */
        set: function(value) {
            if (this.id_ !== value) {
              this.element.id = value;
              this.id_ = value;
              this.dispatchEvent('idChanged');
            }
        }
    },
    /** @export */
    className: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.className_;
        },
        /** @this {org.apache.flex.core.UIBase} */
        set: function(value) {
            if (this.className_ !== value) {
              this.element.className = this.typeNames ? value + ' ' + this.typeNames : value;
              this.className_ = value;
              this.dispatchEvent('classNameChanged');
            }
        }
    },
    /** @export */
    model: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            if (this.model_ == null) {
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
            return this.model_;
        },
        /** @this {org.apache.flex.core.UIBase} */
        set: function(value) {
            if (this.model_ !== value) {
              this.addBead(value);
              this.dispatchEvent('modelChanged');
            }
        }
    },
    /** @export */
    style: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.style_;
        },
        /** @this {org.apache.flex.core.UIBase} */
        set: function(value) {
            if (this.style_ !== value) {
              if (typeof(value) == 'string')
                value = org.apache.flex.core.ValuesManager.valuesImpl.parseStyles(value);
              this.style_ = value;
              if (value.addEventListener)
                value.addEventListener(org.apache.flex.events.ValueChangeEvent.VALUE_CHANGE,
                    goog.bind(this.styleChangeHandler, this));
              this.dispatchEvent('stylesChanged');
            }
        }
    },
    /** @export */
    visible: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return this.positioner.style.display !== 'none';
        },
        /** @this {org.apache.flex.core.UIBase} */
        set: function(value) {
            var oldValue = this.positioner.style.display !== 'none';
            if (value !== oldValue) {
              if (!value) {
                this.lastDisplay_ = this.positioner.style.display;
                this.positioner.style.display = 'none';
                this.dispatchEvent(new org.apache.flex.events.Event('hide'));
              } else {
                if (this.lastDisplay_) {
                  this.positioner.style.display = this.lastDisplay_;
                } else {
                  this.positioner.style.display = this.positioner.internalDisplay;
                }
                this.dispatchEvent(new org.apache.flex.events.Event('show'));
              }
              this.dispatchEvent(new org.apache.flex.events.Event('visibleChanged'));
           }
        }
    },
    /** @export */
    topMostEventDispatcher: {
        /** @this {org.apache.flex.core.UIBase} */
        get: function() {
            return document.body.flexjs_wrapper;
        }
    }
});


/**
 * @export
 * @param {number} value The height of the object in pixels.
 * @param {boolean=} opt_noEvent Whether to skip sending a change event.
 */
org.apache.flex.core.UIBase.prototype.setHeight =
    function(value, opt_noEvent)
{
  if (opt_noEvent === undefined)
    opt_noEvent = false;

  if (value === undefined)
    value = 0;

  var _height = this.CSSHeight;
  if (isNaN(_height) || _height != value) {
    this.positioner.style.height = value.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('heightChanged');
  }
};


/**
 * @export
 * @param {number} value The width of the object in pixels.
 * @param {boolean=} opt_noEvent Whether to skip sending a change event.
 */
org.apache.flex.core.UIBase.prototype.setWidth =
    function(value, opt_noEvent)
{
  if (opt_noEvent === undefined)
    opt_noEvent = false;

  if (value === undefined)
    value = 0;

  var _width = this.CSSWidth;
  if (isNaN(_width) || _width != value) {
    this.positioner.style.width = value.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('widthChanged');
  }
};


/**
 * @export
 * @param {number} newWidth The width of the object in pixels.
 * @param {number} newHeight The height of the object in pixels.
 * @param {boolean=} opt_noEvent Whether to skip sending a change event.
 */
org.apache.flex.core.UIBase.prototype.setWidthAndHeight =
    function(newWidth, newHeight, opt_noEvent)
{
  if (opt_noEvent === undefined)
    opt_noEvent = false;

  if (newWidth === undefined)
    newWidth = 0;
  if (newHeight === undefined)
    newHeight = 0;

  var _width = this.CSSWidth;
  if (isNaN(_width) || _width != newWidth) {
    this.positioner.style.width = newWidth.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('widthChanged');
  }
  var _height = this.CSSHeight;
  if (isNaN(_height) || _height != newHeight) {
    this.positioner.style.height = newHeight.toString() + 'px';
    if (!opt_noEvent)
      this.dispatchEvent('heightChanged');
  }
  this.dispatchEvent('sizeChanged');
};


/**
 * @export
 * @return {boolean} True if width sized to content.
 */
org.apache.flex.core.UIBase.prototype.isWidthSizedToContent = function()
{
  return (isNaN(this.explicitWidth_) && isNaN(this.percentWidth_));
};


/**
 * @export
 * @return {boolean} True if height sized to content.
 */
org.apache.flex.core.UIBase.prototype.isHeightSizedToContent = function()
{
  return (isNaN(this.explicitHeight_) && isNaN(this.percentHeight_));
};


/**
 * @export
 * @type {string}
 */
org.apache.flex.core.UIBase.prototype.typeNames = '';


/**
 * @export
 * @param {org.apache.flex.events.ValueChangeEvent} value The new style properties.
 */
org.apache.flex.core.UIBase.prototype.styleChangeHandler = function(value) {
  var newStyle = {};
  newStyle[value.propertyName] = value.newValue;
  org.apache.flex.core.ValuesManager.valuesImpl.applyStyles(this, newStyle);
};
