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
// createjs
// ------------------------------------------------------------------

// Bring in the createjs sources. You can use the minified versions for
// better performance.
//var mainjs = document.createElement('script');
//mainjs.src = './createjs/easeljs-0.6.0.min.js';
//document.head.appendChild(mainjs);

// ------------------------------------------------------------------
// end createjs
// ------------------------------------------------------------------
 
goog.provide('org.apache.flex.createjs.Application');

//goog.require('org.apache.flex.core.HTMLElementWrapper');

goog.require('org.apache.flex.core.SimpleValuesImpl');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.createjs.core.ViewBase');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');

/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.createjs.Application = function() {
    org.apache.flex.core.HTMLElementWrapper.call(this);

    /**
     * @private
     * @type {Array.<Object>}
     */
    this.queuedListeners_;

};
goog.inherits(org.apache.flex.createjs.Application,
    org.apache.flex.core.HTMLElementWrapper);

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.createjs.Application.prototype.controller = null;

/**
 * @expose
 * @type {org.apache.flex.createjs.core.ViewBase}
 */
org.apache.flex.createjs.Application.prototype.initialView = null;

/**
 * @expose
 * @type {createjs.Stage}
 */
org.apache.flex.createjs.Application.prototype.stage = null;

/**
 * @expose
 * @type {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.createjs.Application.prototype.model = null;

/**
 * @expose
 * @type {org.apache.flex.core.SimpleValuesImpl}
 */
org.apache.flex.createjs.Application.prototype.valuesImpl = null;

/**
 * @this {org.apache.flex.createjs.Application}
 * @param {string} t The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.createjs.Application.prototype.addEventListener = function(t, fn) {
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
 * @this {org.apache.flex.createjs.Application}
 */
org.apache.flex.createjs.Application.prototype.start = function() {
    var evt, i, n, q;
    
    // For createjs, the application is the same as the canvas
    // and it provides convenient access to the stage.
    
	this.element = document.createElement('canvas');
	this.element.id = 'flexjsCanvas';
	this.element.width = 700;
	this.element.height = 500;

    var body = document.getElementsByTagName('body')[0];
    body.appendChild(this.element);
   
    this.stage = new createjs.Stage("flexjsCanvas");

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

    this.initialView.addToParent(this.stage);
    this.initialView.initUI(this.model);

    evt = this.createEvent('viewChanged');
    this.dispatchEvent(evt);
};

