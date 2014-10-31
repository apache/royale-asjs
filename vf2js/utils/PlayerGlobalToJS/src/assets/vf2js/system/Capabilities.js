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
 * @fileoverview 'vf2js.system.Capabilities'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.system.Capabilities');



/**
 * @constructor
 * @struct
 */
vf2js.system.Capabilities = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.system.Capabilities.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Capabilities', qName: 'vf2js.system.Capabilities'}],
      interfaces: [] };


//------------------------------------------------------------------------------
//
//  STATIC PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * language
 *
 * @return {string}
 */
vf2js.system.Capabilities.get_language = function() {
	return 'en';
};


/**
 * playerType
 *
 * @return {string}
 */
vf2js.system.Capabilities.get_playerType = function() {
	return 'PlugIn';
};


/**
 * screenDPI
 *
 * @return {Number}
 */
vf2js.system.Capabilities.get_screenDPI = function() {
	return 72;
};


/**
 * version
 *
 * @return {string}
 */
vf2js.system.Capabilities.get_version = function() {
	return 'MAC 15,0,0,0';
};


/**
 * os
 *
 * @return {string}
 */
vf2js.system.Capabilities.get_os = function() {
	return 'Mac OS 10.9.5';
};
