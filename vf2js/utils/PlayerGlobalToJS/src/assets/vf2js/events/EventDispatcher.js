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
 * @fileoverview 'vf2js.events.EventDispatcher'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.events.EventDispatcher');

goog.require('goog.events.EventTarget');



/**
 * @constructor
 * @struct
 * @param {IEventDispatcher=} opt_arg0 Argument 0 (optional)
 */
vf2js.events.EventDispatcher = function(opt_arg0) {
	this.eventTarget_ = new goog.events.EventTarget();

    this.listeners_ = [];
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.events.EventDispatcher.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'EventDispatcher', qName: 'vf2js.events.EventDispatcher'}],
      interfaces: [] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * listeners_
 *
 * @private
 *
 * @type {Array.<string>}
 */
vf2js.events.EventDispatcher.prototype.listeners_;


/**
 * eventTarget_
 *
 * @private
 *
 * @type {goog.events.EventTarget}
 */
vf2js.events.EventDispatcher.prototype.eventTarget_;


//------------------------------------------------------------------------------
//
//  METHODS
//
//------------------------------------------------------------------------------


/**
 * dispatchEvent
 *
 * @param {Event} arg0 Argument 0
 *
 * @return {boolean}
 */
vf2js.events.EventDispatcher.prototype.dispatchEvent = function(arg0) {
    console.log('$ dispatchEvent: ' + arg0.get_type());
    
    return this.eventTarget_.dispatchEvent(arg0.get_type());
};


/**
 * addEventListener
 *
 * @param {string} arg0 Argument 0
 * @param {Function} arg1 Argument 1
 * @param {boolean=} opt_arg2 Argument 2 (optional)
 * @param {number=} opt_arg3 Argument 3 (optional)
 * @param {boolean=} opt_arg4 Argument 4 (optional)
 */
vf2js.events.EventDispatcher.prototype.addEventListener = function(arg0, arg1, opt_arg2, opt_arg3, opt_arg4) {
  console.log('Listen for event: ' + arg0);
  
  if (!this.hasEventListener(arg0)) {
    this.listeners_.push(arg0);

    this.eventTarget_.listen(arg0, arg1);
  }
};


/**
 * hasEventListener
 *
 * @param {string} arg0 Argument 0
 *
 * @return {boolean}
 */
vf2js.events.EventDispatcher.prototype.hasEventListener = function(arg0) {
  return this.listeners_.indexOf(arg0) > -1;
};


/**
 * removeEventListener
 *
 * @param {string} arg0 Argument 0
 * @param {Function} arg1 Argument 1
 * @param {boolean=} opt_arg2 Argument 2 (optional)
 */
vf2js.events.EventDispatcher.prototype.removeEventListener = function(arg0, arg1, opt_arg2) {
  console.log('Unlisten event: ' + arg0);
  
  this.listeners_.splice(this.listeners_.indexOf(arg0), 1);
  
  this.eventTarget_.unlisten(arg0, arg1);
};


/**
 * toString
 *
 * @return {string} The string
 */
vf2js.events.EventDispatcher.prototype.toString = function() {
  //return this.toString();
};
