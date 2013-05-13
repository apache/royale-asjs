/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.core.HTMLElementWrapper');

goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.core.HTMLElementWrapper = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.core.HTMLElementWrapper,
    org.apache.flex.events.EventDispatcher);


/**
 * @protected
 * @type {Object}
 */
org.apache.flex.core.HTMLElementWrapper.prototype.element = null;


/**
 * @protected
 * @type {Object}
 */
org.apache.flex.core.HTMLElementWrapper.prototype.strand = null;


/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {Object} bead The new bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.addBead = function(bead) {
  if (!this.strand) {
    this.strand = [];
  }

  this.strand.push(bead);

  if (bead.constructor.$implements !== undefined &&
      bead.constructor.$implements.IBeadModel !== undefined) {
    this.model = bead;
  }

  bead.set_strand(this);
};


/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {Object} classOrInterface The requested bead type.
 * @return {Object} The bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.getBeadByType =
    function(classOrInterface) {
  var bead, i, n;

  n = this.strand.length;
  for (i = 0; i < n; i++) {
    bead = this.strand[i];

    if (bead instanceof classOrInterface) {
      return bead;
    }

    if (bead.constructor.$implements.hasOwnProperty(classOrInterface)) {
      return bead;
    }
  }

  return null;
};


/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @return {Array} The array of descriptors.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.get_MXMLDescriptor =
    function() {
  return null;
};


/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @return {Array} The array of properties.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.get_MXMLProperties =
    function() {
  return null;
};


/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {Object} bead The bead to remove.
 * @return {Object} The bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.removeBead = function(bead) {
  var i, n, value;

  n = this.strand.length;
  for (i = 0; i < n; i++) {
    value = this.strand[i];

    if (bead === value) {
      this.strand.splice(i, 1);

      return bead;
    }
  }

  return null;
};


/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {Object} value The new strand.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.set_strand =
    function(value) {
  if (this.strand !== value) {
    this.strand = value;
  }
};

/**
 Hack to allow event.target expressions to work
 * @expose
 * @this {Event}
 * @return {Object} The wrapping object.
 */
Event.prototype.get_target = function() {
  var obj = this.target.flexjs_wrapper;
  return obj;
};

/**
 Hack to allow event.target expressions to work
 * @expose
 * @this {goog.events.BrowserEvent}
 * @return {Object} The wrapping object.
 */
goog.events.BrowserEvent.prototype.get_target = function() {
  return this.event_.get_target();
};
