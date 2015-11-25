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
 * @fileoverview 'vf2js.events.Event'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.events.Event');



/**
 * @constructor
 * @struct
 * @param {string} arg0 Argument 0
 * @param {boolean=} opt_arg1 Argument 1 (optional)
 * @param {boolean=} opt_arg2 Argument 2 (optional)
 */
vf2js.events.Event = function(arg0, opt_arg1, opt_arg2) {
    this._type = arg0;
	
    opt_arg1 = (opt_arg1 !== undefined) ? opt_arg1 : false;
    this._bubbles = opt_arg1;
  
    opt_arg2 = (opt_arg2 !== undefined) ? opt_arg2 : false;
    this._cancelable = opt_arg2;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.events.Event.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Event', qName: 'vf2js.events.Event'}],
      interfaces: [] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * _bubbles
 *
 * @private
 *
 * @type{boolean}
 */
vf2js.events.Event.prototype._bubbles;


/**
 * bubbles
 *
 * @return {boolean}
 */
vf2js.events.Event.prototype.get_bubbles = function() {
    return this._bubbles;
};


/**
 * _cancelable
 *
 * @private
 *
 * @type{boolean}
 */
vf2js.events.Event.prototype._cancelable;


/**
 * cancelable
 *
 * @return {boolean}
 */
vf2js.events.Event.prototype.get_cancelable = function() {
    return this._cancelable;
};


/**
 * _type
 *
 * @private
 *
 * @type{string}
 */
vf2js.events.Event.prototype._type;


/**
 * type
 *
 * @return {string}
 */
vf2js.events.Event.prototype.get_type = function() {
    return this._type;
};


//------------------------------------------------------------------------------
//
//  METHODS
//
//------------------------------------------------------------------------------


/**
 * toString
 *
 * @return {string}
 */
vf2js.events.Event.prototype.toString = function() {
    return '[Event type=' + this._type + ' bubbles=' + this._bubbles + ' cancelable=' + this._cancelable + ']';
};
