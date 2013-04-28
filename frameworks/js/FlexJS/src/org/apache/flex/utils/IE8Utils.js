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

goog.provide('org.apache.flex.utils.IE8Utils');

/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.utils.IE8Utils = function(obj, fn) {
    /*
    obj.attachEvent("onmousedown", 
        org.apache.flex.FlexGlobals.createProxy(this, this.mouseDownHandler));
    obj.attachEvent("onmouseup", 
        org.apache.flex.FlexGlobals.createProxy(this, this.mouseUpHandler));
    obj.attachEvent("onmouseup", 
        org.apache.flex.FlexGlobals.createProxy(this, this.mouseUpHandler));
        */
};

/**
 * @expose
 * Adds an event listener for IE8
 * @param {object} obj The object that we're adding a listener to.
 * @param {object} el The html element we listen to if possible.
 * @param {string} t The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.utils.IE8Utils.addEventListener = function(obj, el, t, fn) {
    var ie8Event = org.apache.flex.utils.IE8Utils.EventMap[t];
    if (ie8Event == undefined)
    {
        if (obj.listeners_ == undefined)
            obj.listeners_ = {};
        
        if (obj.listeners_[t] == undefined)
        {
            obj.listeners_[t] = [ fn ];
        }
        else
            obj.listeners_[t].push(fn);
    /*
        if (t == "click")
        {
            var proxy = new org.apache.flex.utils.IE8Utils(obj, fn);
        }
    */
    }
    else
        el.attachEvent(ie8Event, fn);
};

/**
 * @expose
 * Dispatches an event for IE8
 * @param {object} obj The object that we're dispatching from.
 * @param {object} el The html element we listen to if possible.
 * @param {object} event The event object.
 */
org.apache.flex.utils.IE8Utils.dispatchEvent = function(obj, el, event) {
    var ie8Event = org.apache.flex.utils.IE8Utils.EventMap[event.type];
    if (ie8Event == undefined)
    {
        var arr, i, n, type;

        type = event.type;

        if (obj.listeners_ && obj.listeners_[type]) {
            arr = obj.listeners_[type];
            n = arr.length;
            for (i = 0; i < n; i++) {
                arr[i](event);
            }
        }
    }
    else
        el.fireEvent(ie8Event, event);
};


/**
 * @enum {string}
 */
org.apache.flex.utils.IE8Utils.EventMap = {
    click: 'onclick',
    change: 'onchange',
    mouseUp: 'onmouseup',
    mouseDown: 'onmousedown',
    mouseMove: 'onmousemove',
    mouseOver: 'onmouseover',
    mouseOut: 'onmouseout'
};

