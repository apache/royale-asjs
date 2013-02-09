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

goog.provide('org.apache.flex.binding.ConstantBinding');

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.FlexObject');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.binding.ConstantBinding = function() {
    org.apache.flex.FlexObject.call(this);
};
goog.inherits(
    org.apache.flex.binding.ConstantBinding, org.apache.flex.FlexObject
);

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.binding.ConstantBinding.prototype.destination = null;

/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.ConstantBinding.prototype.destinationPropertyName = '';

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.binding.ConstantBinding.prototype.source = null;

/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.ConstantBinding.prototype.sourcePropertyName = '';

/**
 * @this {org.apache.flex.binding.ConstantBinding}
 * @param {object} value The strand (owner) of the bead.
 */
org.apache.flex.binding.ConstantBinding.prototype.set_strand = function(value) {
    this.destination = value;
    this.source = this.document[this.sourceID];

    this.destination['set_' + this.destinationPropertyName](
        this.source['get_' + this.sourcePropertyName]()
    );
};

/**
 * @this {org.apache.flex.binding.ConstantBinding}
 * @param {object} document The MXML object.
 * @param {string} id The id for the instance.
 */
org.apache.flex.binding.ConstantBinding.prototype.setDocument =
                                                    function(document, id) {
    this.document = document;
};
