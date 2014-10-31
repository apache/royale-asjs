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
 * @fileoverview 'vf2js.display.LoaderInfo'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.display.LoaderInfo');

goog.require('vf2js.events.EventDispatcher');



/**
 * @constructor
 * @struct
 * @extends {vf2js.events.EventDispatcher}
 */
vf2js.display.LoaderInfo = function() {
  vf2js.display.LoaderInfo.base(this, 'constructor');
};
goog.inherits(vf2js.display.LoaderInfo, vf2js.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.display.LoaderInfo.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'LoaderInfo', qName: 'vf2js.display.LoaderInfo'}],
      interfaces: [flash.events.IEventDispatcher] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * width
 *
 * @return {number}
 */
vf2js.display.LoaderInfo.prototype.get_width = function() {
	return 1024;
};


/**
 * bytesLoaded
 *
 * @return {number}
 */
vf2js.display.LoaderInfo.prototype.get_bytesLoaded = function() {
	return 1;
};


/**
 * height
 *
 * @return {number}
 */
vf2js.display.LoaderInfo.prototype.get_height = function() {
	return 768;
};


/**
 * url
 *
 * @return {string}
 */
vf2js.display.LoaderInfo.prototype.get_url = function() {
	console.log('vf2js.display.LoaderInfo.get_url');
	
	return document.location.url;
};


/**
 * bytesTotal
 *
 * @return {number}
 */
vf2js.display.LoaderInfo.prototype.get_bytesTotal = function() {
	return 1;
};


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
vf2js.display.LoaderInfo.prototype.dispatchEvent = function(arg0) {
  return vf2js.display.LoaderInfo.base(this, 'dispatchEvent', arg0);
};
