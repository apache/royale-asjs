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

goog.require('org.apache.flex.core.HTMLElementWrapper');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.createjs.Application = function() {
  org.apache.flex.createjs.Application.base(this, 'constructor');
};
goog.inherits(org.apache.flex.createjs.Application,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * @export
 * @type {Object}
 */
org.apache.flex.createjs.Application.prototype.controller = null;


/**
 * @export
 * @type {org.apache.flex.createjs.core.ViewBase}
 */
org.apache.flex.createjs.Application.prototype.initialView = null;


/**
 * @export
 * @type {createjs.Stage}
 */
org.apache.flex.createjs.Application.prototype.stage = null;


/**
 * @export
 * @type {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.createjs.Application.prototype.model = null;


/**
 * @export
 * @type {org.apache.flex.core.SimpleValuesImpl}
 */
org.apache.flex.createjs.Application.prototype.valuesImpl = null;


/**
 * @export
 */
org.apache.flex.createjs.Application.prototype.start = function() {
  var body;

  // For createjs, the application is the same as the canvas
  // and it provides convenient access to the stage.

  this.element = document.createElement('canvas');
  this.element.id = 'flexjsCanvas';
  this.element.width = 700;
  this.element.height = 500;

  body = document.getElementsByTagName('body')[0];
  body.appendChild(this.element);

  this.stage = new createjs.Stage('flexjsCanvas');

  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this,
      this.MXMLProperties);

  this.dispatchEvent('initialize');

  this.initialView.applicationModel = this.model;
  this.addElement(this.initialView);

  this.dispatchEvent('viewChanged');
};


/**
 * @param {Object} c The child element.
 */
org.apache.flex.createjs.core.Application.prototype.addElement =
    function(c) {
  this.stage.addChild(c.element);
  c.addedToParent();
};

