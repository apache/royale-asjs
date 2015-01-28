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
 * org_apache_cordova_Application
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_cordova_Application');

goog.require('org_apache_flex_core_Application');



/**
 * @constructor
 * @extends {org_apache_flex_core_Application}
 */
org_apache_cordova_Application = function() {
  org_apache_cordova_Application.base(this, 'constructor');

  document.addEventListener('deviceready',
                             goog.bind(this.devicereadyredispatcher, this),
                             false);
};
goog.inherits(org_apache_cordova_Application,
              org_apache_flex_core_Application);


/**
 * @protected
 * @param {Object} event
 */
org_apache_cordova_Application.prototype.devicereadyredispatcher = function(event) {
  this.dispatchEvent('deviceready');
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_cordova_Application.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'Application', qName: 'org_apache_cordova_Application'}]
};
