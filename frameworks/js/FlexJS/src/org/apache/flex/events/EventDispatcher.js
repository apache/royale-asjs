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

goog.provide('org.apache.flex.events.EventDispatcher');

goog.require('org.apache.flex.FlexGlobal');

/**
 * @constructor
 * @extends {org.apache.flex.FlexGlobal}
 */
org.apache.flex.events.EventDispatcher = function() {
    org.apache.flex.FlexGlobal.call(this);

    /**
     * @private
     * @type {Object}
     */
    this.listeners_ = {};
};
goog.inherits(org.apache.flex.events.EventDispatcher,
    org.apache.flex.FlexGlobal);

/**
 * @this {org.apache.flex.events.EventDispatcher}
 * @param {string} type The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.events.EventDispatcher.prototype.addEventListener = function(type, fn) {
    if (!this.listeners_.type) {
        this.listeners_[type] = [];
    }

    this.listeners_[type].push(fn);
};

/**
 * @this {org.apache.flex.events.EventDispatcher}
 * @param {string} type The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.events.EventDispatcher.prototype.removeEventListener = function(type, fn) {
    if (!this.listeners_.type) {
        return;
    }

    var listeners = this.listeners_[type];
    var n = listeners.length;
    for (var i = 0; i < n; i++)
    {
        if (fn == listeners[i])
        {
            listeners.splice(i, 1);
            break;
        }
    }
};

/**
 * @this {org.apache.flex.events.EventDispatcher}
 * @param {Object} event The event to dispatch.
 */
org.apache.flex.events.EventDispatcher.prototype.dispatchEvent = function(event) {
    var arr, i, n, type;

    type = event.type;

    if (this.listeners_[type]) {
        arr = this.listeners_[type];
        n = arr.length;
        for (i = 0; i < n; i++) {
            arr[i](event);
        }
    }
};
