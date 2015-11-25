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

goog.provide('MyInitialView');

goog.require('org.apache.flex.FlexGlobal');

goog.require('org.apache.flex.core.ViewBase');
goog.require('org.apache.flex.html.Label');
goog.require('org.apache.flex.html.TextButton');

/**
 * @constructor
 * @extends {org.apache.flex.core.ViewBase}
 */
MyInitialView = function() {
    org.apache.flex.core.ViewBase.call(this);
};
goog.inherits(MyInitialView, org.apache.flex.core.ViewBase);

/**
 * @override
 * @this {org.apache.flex.core.ViewBase}
 * @return {Array} The array of UI element descriptors.
 */
MyInitialView.prototype.get_uiDescriptors = function() {
    return [
        org.apache.flex.html.Label,
            null,
            'lbl',
            2, 'x', 100, 'y', 25,
            0,
            0,
            1, 'text', 0, 'model', 'labelText', 'labelTextChanged',
        org.apache.flex.html.TextButton,
            null,
            null,
            3, 'text', 'OK', 'x', 100, 'y', 75,
            0,
            1, 'click', this.clickHandler, 0
    ];
};

/**
 * @this {MyInitialView}
 * @param {flash.events.Event} event The event.
 */
MyInitialView.prototype.clickHandler = function(event) {
    this.dispatchEvent(
        /** @type {flash.events.Event} */ (
            org.apache.flex.FlexGlobal.newObject(
                flash.events.Event, ['buttonClicked']
            )
        )
    );
};
