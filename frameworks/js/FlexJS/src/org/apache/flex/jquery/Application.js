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

// (erikdebruin) do these have to be in the global namespace?
var head, link, mainjs, uijs;

// Bring in the jQuery sources. You can use the minified versions for
// better performance.
mainjs = document.createElement('script');
/** @type {Object} */ mainjs.src = 'http://code.jquery.com/jquery-1.9.1.js';
document.head.appendChild(mainjs);

uijs = document.createElement('script');
/** @type {Object} */ uijs.src =
    'http://code.jquery.com/ui/1.10.2/jquery-ui.js';
document.head.appendChild(uijs);

// create a stylesheet link to the corresponding jquery theme file.
head = document.getElementsByTagName('head')[0];
link = document.createElement('link');
/** @type {Object} */ link.id = 'jquerycss';
/** @type {Object} */ link.rel = 'stylesheet';
/** @type {Object} */ link.type = 'text/css';
/** @type {Object} */ link.href =
    'http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css';
/** @type {Object} */ link.media = 'all';
head.appendChild(link);

// ------------------------------------------------------------------
// end jQuery
// ------------------------------------------------------------------

goog.provide('org.apache.flex.jquery.Application');

goog.require('org.apache.flex.core.HTMLElementWrapper');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.jquery.Application = function() {
  goog.base(this);

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
 * @expose
 * @this {org.apache.flex.jquery.Application}
 */
org.apache.flex.jquery.Application.prototype.start = function() {
  var evt, i, n, q;

  this.element = document.getElementsByTagName('body')[0];

  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this,
      this.get_MXMLProperties());

  this.dispatchEvent('initialize');

  this.initialView.addToParent(this.element);
  this.initialView.initUI(this.model);

  this.dispatchEvent('viewChanged');
};

