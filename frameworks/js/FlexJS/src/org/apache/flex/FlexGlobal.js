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

goog.provide('org.apache.flex.FlexGlobal');

goog.require('org.apache.flex.events.Event');
goog.require('org.apache.flex.events.CustomEvent');

/**
 * @constructor
 */
org.apache.flex.FlexGlobal = function() {};

/**
 * @param {Object} context The context.
 * @param {?} method The method.
 * @return {function (?): void} Return new proxy.
 */
org.apache.flex.FlexGlobal.createProxy = function(context, method) {
    return function(value) {
        method.apply(context, [value]);
    };
};

/**
 * @param {?} ctor The creator.
 * @param {Array} ctorArgs The creator arguments.
 * @return {Object} Return the new object.
 */
org.apache.flex.FlexGlobal.newObject = function(ctor, ctorArgs) {
    var evt;

    if ((ctor === org.apache.flex.events.Event ||
         ctor === org.apache.flex.events.CustomEvent) && 
         ctorArgs.length === 1) {
        evt = document.createEvent('Event');
        evt.initEvent(ctorArgs[0], false, false);

        return evt;
    }

    if (ctorArgs.length === 1) {
        return new ctor(ctorArgs[0]);
    }

    if (ctorArgs.length === 0) {
        return new ctor();
    }

    return {};
};

/**
 * @enum {string}
 */
org.apache.flex.FlexGlobal.EventMap = {
    CLICK: 'onClick'
};
