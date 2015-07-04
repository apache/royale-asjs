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

goog.provide('org_apache_flex_core_ClassFactory');

goog.require('org_apache_flex_core_IFactory');



/**
 * @constructor
 * @implements {org_apache_flex_core_IFactory}
 * @param {Function} generator The class definition to use for newInstance.
 */
org_apache_flex_core_ClassFactory = function(generator) {
  /**
   * @private
   * @type {Function}
   */
  this.generator_ = generator;
  this.properties_ = null;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_ClassFactory.prototype.
    FLEXJS_CLASS_INFO =
        { names: [{ name: 'ClassFactory',
           qName: 'org_apache_flex_core_ClassFactory' }],
    interfaces: [org_apache_flex_core_IFactory] };


/**
 * @export
 * @return {Object} The new instance of the class described by generator.
 */
org_apache_flex_core_ClassFactory.
    prototype.newInstance = function() {
  var obj = new this.generator_();

  if (this.properties_) {
    var prop;
    for (prop in this.properties_) {
      obj[prop] = this.properties_[prop];
    }
  }

  return obj;
};
