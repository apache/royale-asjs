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
 * @fileoverview 'vf2js.utils.getDefinitionByName'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.utils.getDefinitionByName');



/**
 * @constructor
 * @struct
 * @param {string} value The qName of the class.
 * @return {Object} A reference to the class.
 */
vf2js.utils.getDefinitionByName = function(value) {
	var fullName;
	
	fullName = value.replace(/::/gi, '.');
	
	console.log('VF2JS (vf2js.utils.getDefinitionByName): ' + fullName);
	
	return eval(fullName + '.prototype');
}; 


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.utils.getDefinitionByName.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'getDefinitionByName', qName: 'vf2js.utils.getDefinitionByName'}],
      interfaces: [ ] };


