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
 * @fileoverview 'vf2js.utils.Timer'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.utils.Timer');

goog.require('vf2js.events.EventDispatcher');
goog.require('flash.events.IEventDispatcher');



/**
 * @constructor
 * @struct
 * @extends {vf2js.events.EventDispatcher}
 * @param {Number} arg0 Argument 0
 * @param {number=} opt_arg1 Argument 1 (optional)
 */
vf2js.utils.Timer = function(arg0, opt_arg1) {
  vf2js.utils.Timer.base(this, 'constructor');
  
  this._delay = arg0;
  
  opt_arg1 = (opt_arg1 !== undefined) ? opt_arg1 : 10;
  this._repeatCount = opt_arg1;
  
  this._currentCount = 0;
};
goog.inherits(vf2js.utils.Timer, vf2js.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.utils.Timer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Timer', qName: 'vf2js.utils.Timer'}],
      interfaces: [flash.events.IEventDispatcher] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * _currentCount
 *
 * @private
 *
 * @type {number}
 */
vf2js.utils.Timer.prototype._currentCount;


/**
 * _delay
 *
 * @private
 *
 * @type {number}
 */
vf2js.utils.Timer.prototype._delay;


/**
 * delay
 *
 * @return {number}
 */
vf2js.utils.Timer.prototype.get_delay = function() {
	return this._delay;
};


/**
 * delay
 *
 * @type {number}
 */
vf2js.utils.Timer.prototype.set_delay = function(value) {
	this._delay = value;
};


/**
 * _repeatCount
 *
 * @private
 *
 * @type {number}
 */
vf2js.utils.Timer.prototype._repeatCount;


//------------------------------------------------------------------------------
//
//  METHODS
//
//------------------------------------------------------------------------------


/**
 * _timerEventHandler
 *
 * @private
 */
vf2js.utils.Timer.prototype._timerEventHandler = function() {
    this.dispatchEvent(new flash.events.TimerEvent(flash.events.TimerEvent.TIMER));

    if (this._running) {
      if (this._repeatCount > 0) {
        this._currentCount++;
  
	    //console.log("### HERE (dispatch) " + this._currentCount);
        if (this._currentCount <= this._repeatCount) {
          setTimeout(goog.bind(this._timerEventHandler, this), this._delay);
        } else {
          this.reset();
        }
      } else {
        setTimeout(goog.bind(this._timerEventHandler, this), this._delay);
      }
    }
};


/**
 * start
 */
vf2js.utils.Timer.prototype.start = function() {
  this._running = true;

  setTimeout(goog.bind(this._timerEventHandler, this), this._delay);
  
  console.log("$ Timer start");
};


/**
 * reset
 */
vf2js.utils.Timer.prototype.reset = function() {
  this.stop();
  
  this._currentCount = 0;
  
  console.log("$ Timer reset");
};


/**
 * stop
 */
vf2js.utils.Timer.prototype.stop = function() {
  this._running = false;
  
  console.log("$ Timer stop");
};


