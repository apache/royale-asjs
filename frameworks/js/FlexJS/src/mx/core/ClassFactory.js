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

goog.provide('mx.core.ClassFactory');

goog.require('mx.core.IFactory');



/**
 * @constructor
 * @implements {mx.core.IFactory}
 */
mx.core.ClassFactory = function(generator) {
  this.generator = generator;
  this.properties = null;
};

/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
mx.core.ClassFactory.prototype.
    FLEXJS_CLASS_INFO =
        { names: [{ name: 'ClassFactory',
           qName: 'mx.core.ClassFactory' }],
    interfaces: [mx.core.IFactory] };

/**
 * @expose
 * @return {Object} The new instance of the class described by generator.
 */
mx.core.ClassFactory.
    prototype.newInstance = function() {
  var obj = new this.generator();

  if (this.properties) {
    var prop;
    for (prop in this.properties) {
      obj[prop] = this.properties[prop];
    }
  }

  return obj;
};