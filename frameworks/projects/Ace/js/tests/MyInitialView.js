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

goog.require('org.apache.royale.FlexGlobal');

goog.require('org.apache.royale.core.ViewBase');
goog.require('org.apache.royale.html.Label');
goog.require('org.apache.royale.html.TextButton');

/**
 * @constructor
 * @extends {org.apache.royale.core.ViewBase}
 */
MyInitialView = function() {
    org.apache.royale.core.ViewBase.call(this);
};
goog.inherits(MyInitialView, org.apache.royale.core.ViewBase);

/**
 * @override
 * @this {org.apache.royale.core.ViewBase}
 * @return {Array} The array of UI element descriptors.
 */
MyInitialView.prototype.get_uiDescriptors = function() {
    return [
        org.apache.royale.html.Label,
            null,
            'lbl',
            2, 'x', 100, 'y', 25,
            0,
            0,
            1, 'text', 0, 'model', 'labelText', 'labelTextChanged',
        org.apache.royale.html.TextButton,
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
            org.apache.royale.FlexGlobal.newObject(
                flash.events.Event, ['buttonClicked']
            )
        )
    );
};
