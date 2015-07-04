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

goog.provide('org_apache_flex_createjs_Application');

goog.require('org_apache_flex_core_HTMLElementWrapper');
goog.require('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org_apache_flex_core_HTMLElementWrapper}
 */
org_apache_flex_createjs_Application = function() {
  org_apache_flex_createjs_Application.base(this, 'constructor');
};
goog.inherits(org_apache_flex_createjs_Application,
    org_apache_flex_core_HTMLElementWrapper);


/**
 * @export
 * @type {Object}
 */
org_apache_flex_createjs_Application.prototype.controller = null;


/**
 * @export
 * @type {org_apache_flex_createjs_core_ViewBase}
 */
org_apache_flex_createjs_Application.prototype.initialView = null;


/**
 * @export
 * @type {createjs.Stage}
 */
org_apache_flex_createjs_Application.prototype.stage = null;


/**
 * @export
 * @type {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_createjs_Application.prototype.model = null;


/**
 * @export
 * @type {org_apache_flex_core_SimpleValuesImpl}
 */
org_apache_flex_createjs_Application.prototype.valuesImpl = null;


/**
 * @export
 */
org_apache_flex_createjs_Application.prototype.start = function() {
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

  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties(this,
      this.MXMLProperties);

  this.dispatchEvent('initialize');

  this.initialView.applicationModel = this.model;
  this.addElement(this.initialView);

  this.dispatchEvent('viewChanged');
};


/**
 * @param {Object} c The child element.
 */
org_apache_flex_createjs_core_Application.prototype.addElement =
    function(c) {
  this.stage.addChild(c.element);
  c.addedToParent();
};

