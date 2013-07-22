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

goog.provide('org.apache.flex.binding.SimpleBinding');

goog.require('org.apache.flex.binding.BindingBase');



/**
 * @constructor
 */
org.apache.flex.binding.SimpleBinding = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.binding.SimpleBinding,
    org.apache.flex.binding.BindingBase);


/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding.prototype.eventName = '';


/**
 * @this {org.apache.flex.binding.SimpleBinding}
 */
org.apache.flex.binding.SimpleBinding.prototype.changeHandler = function() {
  this.destination['set_' + this.destinationPropertyName](
    this.source['get_' + this.sourcePropertyName]()
  );
};


/**
 * @override
 * @this {org.apache.flex.binding.SimpleBinding}
 * @param {Object} value The strand (owner) of the bead.
 */
org.apache.flex.binding.SimpleBinding.prototype.set_strand = function(value) {
  goog.base(this, 'set_strand', value);

  this.source.addEventListener(this.eventName,
      goog.bind(this.changeHandler, this));

  this.changeHandler();
};
