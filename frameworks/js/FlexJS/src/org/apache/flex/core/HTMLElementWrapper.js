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

goog.provide('org_apache_flex_core_HTMLElementWrapper');

goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_core_IStrand');
goog.require('org_apache_flex_events_EventDispatcher');
goog.require('org_apache_flex_utils_Language');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_core_HTMLElementWrapper = function() {
  org_apache_flex_core_HTMLElementWrapper.base(this, 'constructor');
};
goog.inherits(org_apache_flex_core_HTMLElementWrapper,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_HTMLElementWrapper.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HTMLElementWrapper',
                qName: 'org_apache_flex_core_HTMLElementWrapper' }],
      interfaces: [org_apache_flex_core_IStrand] };


/**
 * @expose
 * @type {EventTarget}
 */
org_apache_flex_core_HTMLElementWrapper.prototype.element = null;


/**
 * @protected
 * @type {Array.<Object>}
 */
org_apache_flex_core_HTMLElementWrapper.prototype.strand = null;


/**
 * @protected
 * @type {boolean}
 */
org_apache_flex_core_HTMLElementWrapper.prototype.internalDisplay = 'none';


/**
 * @expose
 * @param {Object} bead The new bead.
 */
org_apache_flex_core_HTMLElementWrapper.prototype.addBead = function(bead) {
  if (!this.strand) {
    this.strand = [];
  }

  this.strand.push(bead);

  if (org_apache_flex_utils_Language.is(bead, org_apache_flex_core_IBeadModel)) {
    this.model = bead;
  }

  bead.set_strand(this);
};


/**
 * @expose
 * @param {!Object} classOrInterface The requested bead type.
 * @return {Object} The bead.
 */
org_apache_flex_core_HTMLElementWrapper.prototype.getBeadByType =
    function(classOrInterface) {
  var bead, i, n;

  n = this.strand.length;
  for (i = 0; i < n; i++) {
    bead = this.strand[i];

    if (org_apache_flex_utils_Language.is(bead, classOrInterface)) {
      return bead;
    }
  }

  return null;
};


/**
 * @expose
 * @return {Array} The array of descriptors.
 */
org_apache_flex_core_HTMLElementWrapper.prototype.get_MXMLDescriptor =
    function() {
  return null;
};


/**
 * @expose
 * @param {Object} bead The bead to remove.
 * @return {Object} The bead.
 */
org_apache_flex_core_HTMLElementWrapper.prototype.removeBead = function(bead) {
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
  var obj = this.target;
  if (!obj)
    return this.currentTarget;
  return obj.flexjs_wrapper;
};


/**
 * Hack to allow event.currentTarget to work
 * @return {Object} The wrapping object.
 */
Event.prototype.get_currentTarget = function() {
  return this.currentTarget.flexjs_wrapper;
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
 * Hack to allow event.currentTarget expressions to work
 *
 * @expose
 * @return {Node|Object} The wrapping object.
 */
goog.events.BrowserEvent.prototype.get_currentTarget = function() {
  // if it is a faked event so just return the currentTarget
  if (!this.event_) return this.currentTarget;
  // for true browser events, get the embedded event's currentTarget
  return this.event_.get_currentTarget();
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


/**
 * Hack to allow event.clientX expressions to work
 *
 * @expose
 * @return {number} The wrapping object.
 */
goog.events.BrowserEvent.prototype.get_clientX = function() {
  return this.clientX;
};


/**
 * Hack to allow event.clientY expressions to work
 *
 * @expose
 * @return {number} The wrapping object.
 */
goog.events.BrowserEvent.prototype.get_clientY = function() {
  return this.clientY;
};


/**
 * Hack to allow event.clientX expressions to work
 *
 * @expose
 * @param {number} value The value.
 */
goog.events.BrowserEvent.prototype.set_clientX = function(value) {
  this.clientX = value;
};


/**
 * Hack to allow event.clientY expressions to work
 *
 * @expose
 * @param {number} value The value.
 */
goog.events.BrowserEvent.prototype.set_clientY = function(value) {
  this.clientY = value;
};
