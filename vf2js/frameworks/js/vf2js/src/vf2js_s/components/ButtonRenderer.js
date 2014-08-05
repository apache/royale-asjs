/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview The renderer for 'Spark' button components.
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js_s.components.ButtonRenderer');

goog.require('goog.ui.ControlRenderer');



/**
 * @constructor
 *
 * @extends {goog.ui.ControlRenderer}
 */
vf2js_s.components.ButtonRenderer = function() {
  vf2js_s.components.ButtonRenderer.base(this, 'constructor');
};
goog.inherits(vf2js_s.components.ButtonRenderer, goog.ui.ControlRenderer);
goog.addSingletonGetter(vf2js_s.components.ButtonRenderer);


//------------------------------------------------------------------------------
//
// Static Constants
//
//------------------------------------------------------------------------------


/**
 * CSS_CLASS
 * 
 * @const
 * 
 * @type {string}
 */
vf2js_s.components.ButtonRenderer.CSS_CLASS =
    'vf2js_s-components-buttonrenderer';


//------------------------------------------------------------------------------
//
//  Methods
//
//------------------------------------------------------------------------------


/**
 * getCssClass
 * 
 * @inheritDoc
 */
vf2js_s.components.ButtonRenderer.prototype.getCssClass = function () {
  return vf2js_s.components.ButtonRenderer.CSS_CLASS;
};


/**
 * createDom
 * 
 * @inheritDoc
 */
vf2js_s.components.ButtonRenderer.prototype.createDom = function (button) {
  var /** @type {?Element} */ element;
  
  element = vf2js_s.components.ButtonRenderer.base(this, 'createDom', button);
  
  element.appendChild(
      goog.dom.createDom('input', { 'type': 'button' }));

  button.setElementInternal(element);
  
  return element;
};
