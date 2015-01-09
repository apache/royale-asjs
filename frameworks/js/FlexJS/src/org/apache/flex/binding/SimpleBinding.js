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
 * @extends {org.apache.flex.binding.BindingBase}
 */
org.apache.flex.binding.SimpleBinding = function() {
  org.apache.flex.binding.SimpleBinding.base(this, 'constructor');
};
goog.inherits(org.apache.flex.binding.SimpleBinding,
    org.apache.flex.binding.BindingBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.binding.SimpleBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleBinding',
                qName: 'org.apache.flex.binding.SimpleBinding'}] };


/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding.prototype.eventName = '';


/**
 * @expose
 */
org.apache.flex.binding.SimpleBinding.prototype.changeHandler = function() {
  if (typeof(this.destination['set_' + this.destinationPropertyName]) === 'function')
    this.destination['set_' + this.destinationPropertyName](
        this.source['get_' + this.sourcePropertyName]()
    );
  else {
    this.destination[this.destinationPropertyName] =
        this.source['get_' + this.sourcePropertyName]();
  }
};


/**
 * @override
 */
org.apache.flex.binding.SimpleBinding.prototype.set_strand = function(value) {
  org.apache.flex.binding.SimpleBinding.base(this, 'set_strand', value);

  if (!this.source)
    return;

  this.source.addEventListener(this.eventName,
      goog.bind(this.changeHandler, this));

  this.changeHandler();
};


/**
 * @param {Object} event The event.
 */
org.apache.flex.binding.SimpleBinding.prototype.sourceChangeHandler = function(event) {
  org.apache.flex.binding.SimpleBinding.base(this, 'sourceChangeHandler', event);
  if (this.source) {
    this.source.addEventListener(this.eventName,
        goog.bind(this.changeHandler, this));
    this.changeHandler();
  }
};