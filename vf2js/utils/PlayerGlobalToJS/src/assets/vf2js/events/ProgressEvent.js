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
 * @fileoverview 'vf2js.events.ProgressEvent'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.events.ProgressEvent');

goog.require('vf2js.events.Event');



/**
 * @constructor
 * @struct
 * @extends {vf2js.events.Event}
 * @param {string} arg0 Argument 0
 * @param {boolean=} opt_arg1 Argument 1 (optional)
 * @param {boolean=} opt_arg2 Argument 2 (optional)
 * @param {Number=} opt_arg3 Argument 3 (optional)
 * @param {Number=} opt_arg4 Argument 4 (optional)
 */
vf2js.events.ProgressEvent = function(arg0, opt_arg1, opt_arg2, opt_arg3, opt_arg4) {
  vf2js.events.ProgressEvent.base(this, 'constructor', arg0, opt_arg1, opt_arg2, opt_arg3, opt_arg4);
};
goog.inherits(vf2js.events.ProgressEvent, vf2js.events.Event);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.events.ProgressEvent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ProgressEvent', qName: 'vf2js.events.ProgressEvent'}],
      interfaces: [] };


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
vf2js.events.ProgressEvent.prototype.toString = function() {
	var /** @type {string} */ result;
	
	result = vf2js.events.TimerEvent.base(this, 'toString');
	result = result.replace('[Event ', '[ProgressEvent ');
	result = result.replace(']', ' bytesLoaded=value bytesTotal=value]');
	
	return result;
};
