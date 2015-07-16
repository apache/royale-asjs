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
goog.require('org.apache.flex.events.BrowserEvent');
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
 * @export
 * @type {EventTarget}
 */
org.apache.flex.core.HTMLElementWrapper.prototype.element = null;


/**
 * @protected
 * @type {Array.<Object>}
 */
org.apache.flex.core.HTMLElementWrapper.prototype._beads = null;


/**
 * @protected
 * @type {string}
 */
org.apache.flex.core.HTMLElementWrapper.prototype.internalDisplay = 'inline';


/**
 * @export
 * @param {Object} bead The new bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.addBead = function(bead) {
  if (!this.beads_) {
    this.beads_ = [];
  }

  this.beads_.push(bead);

  if (org.apache.flex.utils.Language.is(bead, org.apache.flex.core.IBeadModel)) {
    this.model = bead;
  }

  bead.strand = this;
};


/**
 * @export
 * @param {!Object} classOrInterface The requested bead type.
 * @return {Object} The bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.getBeadByType =
    function(classOrInterface) {
  var bead, i, n;

  n = this.beads_.length;
  for (i = 0; i < n; i++) {
    bead = this.beads_[i];

    if (org.apache.flex.utils.Language.is(bead, classOrInterface)) {
      return bead;
    }
  }

  return null;
};


Object.defineProperties(org.apache.flex.core.HTMLElementWrapper.prototype, {
    /** @export */
    MXMLDescriptor: {
        get: function() {
            return null;
        }
    }
});


/**
 * @export
 * @param {Object} bead The bead to remove.
 * @return {Object} The bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.removeBead = function(bead) {
  var i, n, value;

  n = this.beads_.length;
  for (i = 0; i < n; i++) {
    value = this.beads_[i];

    if (bead === value) {
      this.beads_.splice(i, 1);

      return bead;
    }
  }

  return null;
};


/**
 * @type {?function((goog.events.Listener), (?Object)):boolean}
 */
org.apache.flex.core.HTMLElementWrapper.googFireListener = null;


/**
 * Fires a listener with a set of arguments
 *
 * @param {goog.events.Listener} listener The listener object to call.
 * @param {Object} eventObject The event object to pass to the listener.
 * @return {boolean} Result of listener.
 */
org.apache.flex.core.HTMLElementWrapper.fireListenerOverride = function(listener, eventObject) {
  var e = new org.apache.flex.events.BrowserEvent();
  e.wrappedEvent = /** @type {goog.events.BrowserEvent} */ (eventObject);
  return org.apache.flex.core.HTMLElementWrapper.googFireListener(listener, e);
};


/**
 * Static initializer
 */
org.apache.flex.core.HTMLElementWrapper.installOverride = function() {
  org.apache.flex.core.HTMLElementWrapper.googFireListener =
      goog.events.fireListener;
  goog.events.fireListener = org.apache.flex.core.HTMLElementWrapper.fireListenerOverride;
};


/**
 * The properties that triggers the static initializer
 */
org.apache.flex.core.HTMLElementWrapper.installedOverride =
    org.apache.flex.core.HTMLElementWrapper.installOverride();

