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

goog.require('org.apache.flex.core.IBeadModel');
goog.require('org.apache.flex.core.IStrand');
goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.core.HTMLElementWrapper = function() {
  org.apache.flex.core.HTMLElementWrapper.base(this, 'constructor');
};
goog.inherits(org.apache.flex.core.HTMLElementWrapper,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.HTMLElementWrapper.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HTMLElementWrapper',
                qName: 'org.apache.flex.core.HTMLElementWrapper' }],
      interfaces: [org.apache.flex.core.IStrand] };


/**
 * @expose
 * @type {EventTarget}
 */
org.apache.flex.core.HTMLElementWrapper.prototype.element = null;


/**
 * @protected
 * @type {Array.<Object>}
 */
org.apache.flex.core.HTMLElementWrapper.prototype.strand = null;


/**
 * @expose
 * @param {Object} bead The new bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.addBead = function(bead) {
  if (!this.strand) {
    this.strand = [];
  }

  this.strand.push(bead);

  if (org.apache.flex.utils.Language.is(bead, org.apache.flex.core.IBeadModel)) {
    this.model = bead;
  }

  bead.set_strand(this);
};


/**
 * @expose
 * @param {!Object} classOrInterface The requested bead type.
 * @return {Object} The bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.getBeadByType =
    function(classOrInterface) {
  var bead, i, n;

  n = this.strand.length;
  for (i = 0; i < n; i++) {
    bead = this.strand[i];

    if (org.apache.flex.utils.Language.is(bead, classOrInterface)) {
      return bead;
    }
  }

  return null;
};


/**
 * @expose
 * @return {Array} The array of descriptors.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.get_MXMLDescriptor =
    function() {
  return null;
};


/**
 * @expose
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
 * Hack to allow event.target expressions to work
 *
 * @expose
 * @return {Object} The wrapping object.
 */
Event.prototype.get_target = function() {
  var obj = this.target.flexjs_wrapper;
  return obj;
};


/**
 * Hack to allow event.target expressions to work
 *
 * @expose
 * @return {Object} The wrapping object.
 */
goog.events.BrowserEvent.prototype.get_target = function() {
  // if it is a faked event so just return the target
  if (!this.event_) return this.target;
  // for true browser events, get the embedded event's target
  return this.event_.get_target();
};


/**
 * Hack to allow event.screenX expressions to work
 *
 * @expose
 * @return {number} The wrapping object.
 */
goog.events.BrowserEvent.prototype.get_screenX = function() {
  return this.screenX;
};


/**
 * Hack to allow event.screenY expressions to work
 *
 * @expose
 * @return {number} The wrapping object.
 */
goog.events.BrowserEvent.prototype.get_screenY = function() {
  return this.screenY;
};
