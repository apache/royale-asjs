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

goog.provide('org.apache.flex.html.HContainer');

goog.require('org.apache.flex.core.IContainer');
goog.require('org.apache.flex.html.Container');



/**
 * @constructor
 * @implements {org.apache.flex.core.IContainer}
 * @extends {org.apache.flex.html.Container}
 */
org.apache.flex.html.HContainer = function() {
  org.apache.flex.html.HContainer.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.HContainer,
    org.apache.flex.html.Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.HContainer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HContainer',
                qName: 'org.apache.flex.html.HContainer' }],
      interfaces: [org.apache.flex.core.IContainer] };
