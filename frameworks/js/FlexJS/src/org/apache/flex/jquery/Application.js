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

// ------------------------------------------------------------------
// jQuery
// ------------------------------------------------------------------

// Bring in the jQuery sources. You can use the minified versions for
// better performance.
 var mainjs = document.createElement('script');
mainjs.src = 'http://code.jquery.com/jquery-1.9.1.js';
document.head.appendChild(mainjs);

 var uijs = document.createElement('script');
uijs.src = 'http://code.jquery.com/ui/1.10.2/jquery-ui.js';
document.head.appendChild(uijs); 

// create a stylesheet link to the corresponding jquery theme file.
var head  = document.getElementsByTagName('head')[0];
var link  = document.createElement('link');
link.id   = 'jquerycss';
link.rel  = 'stylesheet';
link.type = 'text/css';
link.href = 'http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css';
link.media = 'all';
head.appendChild(link);

// ------------------------------------------------------------------
// end jQuery
// ------------------------------------------------------------------
 
goog.provide('org.apache.flex.jquery.Application');

goog.require('org.apache.flex.core.HTMLElementWrapper');

goog.require('org.apache.flex.core.SimpleValuesImpl');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.core.ViewBase');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');

/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.jquery.Application = function() {
    org.apache.flex.core.HTMLElementWrapper.call(this);

    /**
     * @private
     * @type {Array.<Object>}
     */
    this.queuedListeners_;

};
goog.inherits(org.apache.flex.jquery.Application,
    org.apache.flex.core.HTMLElementWrapper);

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.jquery.Application.prototype.controller = null;

/**
 * @expose
 * @type {org.apache.flex.core.ViewBase}
 */
org.apache.flex.jquery.Application.prototype.initialView = null;

/**
 * @expose
 * @type {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.jquery.Application.prototype.model = null;

/**
 * @expose
 * @type {org.apache.flex.core.SimpleValuesImpl}
 */
org.apache.flex.jquery.Application.prototype.valuesImpl = null;

/**
 * @this {org.apache.flex.jquery.Application}
 * @param {string} t The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.jquery.Application.prototype.addEventListener = function(t, fn) {
    if (!this.element) {
        if (!this.queuedListeners_) {
            this.queuedListeners_ = [];
        }

        this.queuedListeners_.push({ type: t, handler: fn });

        return;
    }

    goog.base(this, 'addEventListener', t, fn);
};

/**
 * @expose
 * @this {org.apache.flex.jquery.Application}
 */
org.apache.flex.jquery.Application.prototype.start = function() {
    var evt, i, n, q;

    this.element = document.getElementsByTagName('body')[0];

    if (this.queuedListeners_) {
        n = this.queuedListeners_.length;
        for (i = 0; i < n; i++) {
            q = this.queuedListeners_[i];

            this.addEventListener(q.type, q.handler);
        }
    }

    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this,
            this.get_MXMLProperties());

    org.apache.flex.core.ValuesManager.valuesImpl = this.valuesImpl;

    evt = this.createEvent('initialize');
    this.dispatchEvent(evt);

    this.initialView.addToParent(this.element);
    this.initialView.initUI(this.model);

    evt = this.createEvent('viewChanged');
    this.dispatchEvent(evt);
};

