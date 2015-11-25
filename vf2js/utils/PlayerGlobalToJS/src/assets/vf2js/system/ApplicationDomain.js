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
 * @fileoverview 'vf2js.system.ApplicationDomain'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.system.ApplicationDomain');



/**
 * @constructor
 * @struct
 * @param {ApplicationDomain=} opt_arg0 Argument 0 (optional)
 */
vf2js.system.ApplicationDomain = function(opt_arg0) {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.system.ApplicationDomain.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ApplicationDomain', qName: 'vf2js.system.ApplicationDomain'}],
      interfaces: [] };


//------------------------------------------------------------------------------
//
//  METHODS
//
//------------------------------------------------------------------------------


/**
 * getDefinition
 *
 * @param {string} arg0 Argument 0
 *
 * @return {Object}
 */
vf2js.system.ApplicationDomain.prototype.getDefinition = function(arg0) {
  	var fullName;

  	fullName = arg0.replace(/::/gi, '.');

  	return eval('new ' + fullName + '()');
};


/**
 * hasDefinition
 *
 * @param {string} arg0 Argument 0
 *
 * @return {boolean}
 */
vf2js.system.ApplicationDomain.prototype.hasDefinition = function(arg0) {
    return true;
};
