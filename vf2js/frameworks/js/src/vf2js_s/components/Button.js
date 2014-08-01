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
 * @fileoverview A 'Spark' button component.
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js_s.components.Button');

goog.require('goog.ui.Control');
goog.require('vf2js_s.components.ButtonRenderer');



/**
 * @constructor
 * 
 * @extends {goog.ui.Control}
 */
vf2js_s.components.Button = function() {
  vf2js_s.components.Button.base(this, 'constructor');
};
goog.inherits(vf2js_s.components.Button, goog.ui.Control);


//------------------------------------------------------------------------------
//
//  Enums
//
//------------------------------------------------------------------------------


/**
 * IdFragment
 *
 * @enum {string}
 */
vf2js_s.components.Button.IdFragment = {
  BUTTON: 'button'
};


//------------------------------------------------------------------------------
//
//  Properties
//
//------------------------------------------------------------------------------


//--------------------------------------
//  id
//--------------------------------------

/**
 * @type {string}
 */
vf2js_s.components.Button.prototype.id;


//--------------------------------------
//  label
//--------------------------------------

/**
 * @private
 * 
 * @type {string}
 */
vf2js_s.components.Button.prototype.label_;

/**
 * @type {string}
 */
vf2js_s.components.Button.prototype.label;

Object.defineProperty(vf2js_s.components.Button.prototype, 'label', {
  get: function () {
    return this.label_;
  },
  set: function (value) {
    var /** @type {Element} */ element;
    
    this.label_ = value;
    
    element = this.getElement();
    if (element) {
      element.firstChild.value = this.label_;
    }
  }
});


//------------------------------------------------------------------------------
//
//  Methods
//
//------------------------------------------------------------------------------


/**
 * enterDocument
 * 
 * @inheritDoc
 */
vf2js_s.components.Button.prototype.enterDocument = function() {
  vf2js_s.components.Button.base(this, 'enterDocument');
  
  this.setId(this.id);
  
  this.label = this.label_;
  
  // - add handlers using 'this.getHandler()'
};


/**
 * exitDocument
 * 
 * @inheritDoc
 */
vf2js_s.components.Button.prototype.exitDocument = function() {
  vf2js_s.components.Button.base(this, 'exitDocument');
  
  // - remove handlers that are not attached with 'this.getHandler()'
};


/**
 * disposeInternal
 * 
 * @inheritDoc
 */
vf2js_s.components.Button.prototype.disposeInternal = function() {
  vf2js_s.components.Button.base(this, 'disposeInternal');
  
  //
};


//------------------------------------------------------------------------------
//
//  Metadata
//
//------------------------------------------------------------------------------


goog.ui.registry.setDefaultRenderer(vf2js_s.components.Button,
    vf2js_s.components.ButtonRenderer);
