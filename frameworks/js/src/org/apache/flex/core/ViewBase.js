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

goog.provide('org.apache.flex.core.ViewBase');

goog.require('org.apache.flex.FlexGlobal');

goog.require('org.apache.flex.binding.SimpleBinding');

goog.require('org.apache.flex.core.UIBase');

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.ViewBase = function() {
    org.apache.flex.core.UIBase.call(this);

     /**
      * @private
      * @type {org.apache.flex.core.ViewBase}
      */
      this.currentObject_;
};
goog.inherits(org.apache.flex.core.ViewBase, org.apache.flex.core.UIBase);

/**
 * @protected
 * @return {Array} The array of UI element descriptors.
 */
org.apache.flex.core.ViewBase.prototype.get_uiDescriptors = function() {
    return [];
};

/**
 * @this {org.apache.flex.core.ViewBase}
 * @param {org.apache.flex.core.Application} app The main application.
 */
org.apache.flex.core.ViewBase.prototype.initUI = function(app) {
    var count, descriptor, descriptors, i, j, n, sb, value;

    descriptors = this.get_uiDescriptors();

    if (descriptors && descriptors.length) {
        n = descriptors.length;
        i = 0;
        while (i < n)
        {
            // class (index 0)
            descriptor = descriptors[i++];
            this.currentObject_ =
                /* : org.apache.flex.core.ViewBase */ new descriptor();
            this.currentObject_.addToParent(this.element);

            // model (index 1)
            descriptor = descriptors[i++];
            if (descriptor) {
                value = new descriptor();
                this.currentObject_.addBead(value);
            }
            if (typeof this.currentObject_.initModel == 'function') {
                this.currentObject_.initModel();
            }

            // id (index 2)
            descriptor = descriptors[i++];
            if (descriptor) {
                this[descriptor] = this.currentObject_;
            }

            // num props
            count = descriptors[i++];
            for (j = 0; j < count; j++) {
                descriptor = descriptors[i++];
                value = descriptors[i++];
                this.currentObject_['set_' + descriptor](value);
            }

            // num beads
            count = descriptors[i++];
            for (j = 0; j < count; j++) {
                descriptor = descriptors[i++];
                value = new descriptor();
                this.currentObject_.addBead(value);
            }
            if (typeof this.currentObject_.initSkin == 'function') {
                this.currentObject_.initSkin();
            }

            // num events
            count = descriptors[i++];
            for (j = 0; j < count; j++) {
                descriptor = descriptors[i++];
                value = descriptors[i++];
                this.currentObject_.addEventListener(
                    descriptor, org.apache.flex.FlexGlobal.createProxy(
                        this, value
                    )
                );
            }

            // num bindings
            count = descriptors[i++];
            for (j = 0; j < count; j++) {
                descriptor = descriptors[i++];
                value = descriptors[i++];
                switch (value) {
                    case 0 : {
                        sb = new org.apache.flex.binding.SimpleBinding();
                        sb.destination = this.currentObject_;
                        sb.destinationPropertyName = descriptor;
                        sb.source = app[descriptors[i++]];
                        sb.sourcePropertyName = descriptors[i++];
                        sb.eventName = descriptors[i++];
                        sb.initialize();

                        break;
                    }
                }
            }
        }
    }
};
