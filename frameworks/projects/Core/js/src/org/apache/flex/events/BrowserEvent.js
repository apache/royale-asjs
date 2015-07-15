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
goog.provide('org.apache.flex.events.BrowserEvent');

goog.require('goog.events.BrowserEvent');



/**
 * @constructor
 */
org.apache.flex.events.BrowserEvent = function() {

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.events.BrowserEvent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BrowserEvent',
                qName: 'org.apache.flex.events.BrowserEvent' }] };


/**
 * @type {?goog.events.BrowserEvent}
 */
org.apache.flex.events.BrowserEvent.prototype.wrappedEvent = null;


/**
 */
org.apache.flex.events.BrowserEvent.prototype.preventDefault = function() {
  this.wrappedEvent.preventDefault();
};


/**
 */
org.apache.flex.events.BrowserEvent.prototype.stopPropagation = function() {
  this.wrappedEvent.stopPropagation();
};


/**
 */
org.apache.flex.events.BrowserEvent.prototype.stopImmediatePropagation = function() {
  //this.wrappedEvent.stopImmediatePropagation(); // not in goog.events.BrowserEvent
  this.wrappedEvent.stopPropagation();
};


Object.defineProperties(org.apache.flex.events.BrowserEvent.prototype, {
    /** @export */
    currentTarget: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            var o = this.wrappedEvent.currentTarget;
            if (o && o.flexjs_wrapper)
              return o.flexjs_wrapper;
            return o;
        }
    },
    /** @export */
    button: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.button;
        }
    },
    /** @export */
    charCode: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.charCode;
        }
    },
    /** @export */
    clientX: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.clientX;
        }
    },
    /** @export */
    clientY: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.clientY;
        }
    },
    /** @export */
    keyCode: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.keyCode;
        }
    },
    /** @export */
    offsetX: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.offsetX;
        }
    },
    /** @export */
    offsetY: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.offsetY;
        }
    },
    /** @export */
    screenX: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.screenX;
        }
    },
    /** @export */
    screenY: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            return this.wrappedEvent.screenY;
        }
    },
    /** @export */
    relatedTarget: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            var o = this.wrappedEvent.relatedTarget;
            if (o && o.flexjs_wrapper)
              return o.flexjs_wrapper;
            return o;
        }
    },
    /** @export */
    target: {
        /** @this {org.apache.flex.events.BrowserEvent} */
        get: function() {
            var o = this.wrappedEvent.target;
            if (o && o.flexjs_wrapper)
              return o.flexjs_wrapper;
            return o;
        }
    }
});


