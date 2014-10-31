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
 * @fileoverview 'vf2js.display.DisplayObjectContainer'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.display.DisplayObjectContainer');

goog.require('vf2js.display.InteractiveObject');



/**
 * @constructor
 * @struct
 * @extends {vf2js.display.InteractiveObject}
 */
vf2js.display.DisplayObjectContainer = function() {
  vf2js.display.DisplayObjectContainer.base(this, 'constructor');
  
  this.children_ = [];
};
goog.inherits(vf2js.display.DisplayObjectContainer, vf2js.display.InteractiveObject);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.display.DisplayObjectContainer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DisplayObjectContainer', qName: 'vf2js.display.DisplayObjectContainer'}],
      interfaces: [] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * children_
 *
 * @private
 *
 * @type {Array.<flash.display.DisplayObject>}
 */
vf2js.display.DisplayObjectContainer.prototype.children_;


//------------------------------------------------------------------------------
//
//  METHODS
//
//------------------------------------------------------------------------------


/**
 * addChildAt
 *
 * @param {flash.display.DisplayObject} arg0 Argument 0
 * @param {number} arg1 Argument 1
 *
 * @return {flash.display.DisplayObject}
 */
vf2js.display.DisplayObjectContainer.prototype.addChildAt = function(arg0, arg1) {
  arg0.$_implementation.set_parent(this);
  
  this.children_[arg1] = arg0;
  
  this.dispatchEvent(new flash.events.Event(flash.events.Event.ADDED));

  return arg0;
};


/**
 * addChild
 *
 * @param {flash.display.DisplayObject} arg0 Argument 0
 *
 * @return {flash.display.DisplayObject}
 */
vf2js.display.DisplayObjectContainer.prototype.addChild = function(arg0) {
  arg0.$_implementation.set_parent(this);
  
  this.children_.push(arg0);
  
  this.dispatchEvent(new flash.events.Event(flash.events.Event.ADDED));

  return arg0;
};
