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

goog.provide('org.apache.flex.html.TitleBar');

goog.require('org.apache.flex.html.Container');
goog.require('org.apache.flex.html.Label');
goog.require('org.apache.flex.html.TextButton');
goog.require('org.apache.flex.html.beads.models.TitleBarModel');



/**
 * @constructor
 * @extends {org.apache.flex.html.Container}
 */
org.apache.flex.html.TitleBar = function() {

  org.apache.flex.html.TitleBar.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.TitleBar,
    org.apache.flex.html.Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.TitleBar.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TitleBar',
                qName: 'org.apache.flex.html.TitleBar'}] };


/**
 * @override
 */
org.apache.flex.html.TitleBar.prototype.createElement =
    function() {

  this.element = document.createElement('div');

  this.positioner = this.element;
  this.positioner.style.position = 'relative';
  this.element.flexjs_wrapper = this;

  this.className = 'TitleBar';

  return this.element;
};


Object.defineProperties(org.apache.flex.html.TitleBar.prototype, {
    /** @export */
    title: {
        /** @this {org.apache.flex.html.TitleBar} */
        get: function() {
            return this.model.title;
        },
        /** @this {org.apache.flex.html.TitleBar} */
        set: function(value) {
            this.model.title = value;
        }
    },
    /** @export */
    showCloseButton: {
        /** @this {org.apache.flex.html.TitleBar} */
        get: function() {
            return this.model.showCloseButton;
        },
        /** @this {org.apache.flex.html.TitleBar} */
        set: function(value) {
            this.model.showCloseButton = value;
        }
    }
});
