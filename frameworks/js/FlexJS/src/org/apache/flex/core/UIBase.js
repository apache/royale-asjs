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
  this.lastDisplay_ = null;

  /**
   * @protected
   * @type {Object}
   */
  this.positioner = null;
};
goog.inherits(org.apache.flex.core.UIBase,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} child The element to be added.
 */
org.apache.flex.core.UIBase.prototype.internalAddChild = function(child) {
  this.element.appendChild(child);
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} child The element to be added.
 * @param {number} index The index for the element to be added.
 */
org.apache.flex.core.UIBase.prototype.internalAddChildAt =
    function(child, index) {
  this.element.insertBefore(child, internalGetChildAt(index));
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} child The element to be removed.
 */
org.apache.flex.core.UIBase.prototype.internalRemoveChild =
    function(child) {
  this.element.removeChild(child);
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {number} index The index.
 * @return {Object} The child.
 */
org.apache.flex.core.UIBase.prototype.internalGetChildAt =
    function(index) {
  return this.element.childNodex[index];
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} p The parent component.
 */
org.apache.flex.core.UIBase.prototype.addToParent = function(p) {
  if (this.element == null)
    this.element = document.createElement('div');

  p.internalAddChild(this.element);
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} p The parent component.
 * @param {number} index The index.
 */
org.apache.flex.core.UIBase.prototype.addToParentAt = function(p, index) {
  if (this.element == null)
    this.element = document.createElement('div');

  p.internalAddChildAt(this.element);
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} p The parent component.
 * @return {number} The index in parent.
 */
org.apache.flex.core.UIBase.prototype.getIndexInParent = function(p) {
  return p.internalGetChildIndex(this.element);
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} p The parent component.
 */
org.apache.flex.core.UIBase.prototype.removeFromParent = function(p) {
  p.internalRemoveChild(this.element);
};


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_x = function(pixels) {
  this.positioner.style.position = 'absolute';
  this.positioner.style.left = pixels.toString() + 'px';
};


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.set_y = function(pixels) {
  this.positioner.style.position = 'absolute';
  this.positioner.style.top = pixels.toString() + 'px';
};


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_width = function(pixels) {
  this.positioner.style.width = pixels.toString() + 'px';
};


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.set_height = function(pixels) {
  this.positioner.style.height = pixels.toString() + 'px';
};


/**
 * @expose
 * @type {string}
 */
org.apache.flex.core.UIBase.prototype.id = null;


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @return {string} The id.
 */
org.apache.flex.core.UIBase.prototype.get_id = function() {
  return this.id;
};


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} value The new id.
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
org.apache.flex.core.UIBase.prototype.className = null;

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @return {string} The className.
 */
org.apache.flex.core.UIBase.prototype.get_className = function() {
    return this.className;
};


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {object} value The new className.
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
 * @type {object}
 */
org.apache.flex.core.UIBase.prototype.model = null;


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @return {Object} The model.
 */
org.apache.flex.core.UIBase.prototype.get_model = function() {
  return this.model;
};


/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
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
 * @this {org.apache.flex.core.UIBase}
 * @return {object} True if visible.
 */
org.apache.flex.core.UIBase.prototype.get_visible = function() {
    return this.element.style.display !== 'none';
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {object} value The new model.
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
