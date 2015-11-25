/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/**
 * org.apache.cordova.Application
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.cordova.Application');

goog.require('org.apache.flex.core.Application');



/**
 * @constructor
 * @extends {org.apache.flex.core.Application}
 */
org.apache.cordova.Application = function() {
  org.apache.cordova.Application.base(this, 'constructor');

  document.addEventListener('deviceready',
                             goog.bind(this.devicereadyredispatcher, this),
                             false);
};
goog.inherits(org.apache.cordova.Application,
              org.apache.flex.core.Application);


/**
 * @protected
 * @param {Object} event
 */
org.apache.cordova.Application.prototype.devicereadyredispatcher = function(event) {
  this.dispatchEvent('deviceready');
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.cordova.Application.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'Application', qName: 'org.apache.cordova.Application'}]
};
