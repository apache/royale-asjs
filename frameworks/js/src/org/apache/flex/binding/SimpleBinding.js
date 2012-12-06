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

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.FlexObject');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.binding.SimpleBinding = function() {
    org.apache.flex.FlexObject.call(this);
};
goog.inherits(
    org.apache.flex.binding.SimpleBinding, org.apache.flex.FlexObject
);

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.binding.SimpleBinding.prototype.destination = null;

/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding.prototype.destinationPropertyName = "";

/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding.prototype.eventName = "";

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.binding.SimpleBinding.prototype.source = null;

/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding.prototype.sourcePropertyName = "";

/**
 * @this {org.apache.flex.binding.SimpleBinding}
 */
org.apache.flex.binding.SimpleBinding.prototype.changeHandler = function() {
    this.destination['set_' + this.destinationPropertyName](
        this.source['get_' + this.sourcePropertyName]()
    );
};

/**
 * @this {org.apache.flex.binding.SimpleBinding}
 */
org.apache.flex.binding.SimpleBinding.prototype.initialize = function() {
    this.source.addEventListener(
        this.eventName, org.apache.flex.FlexGlobal.createProxy(
            this, this.changeHandler
        )
    );

    this.changeHandler();
};
