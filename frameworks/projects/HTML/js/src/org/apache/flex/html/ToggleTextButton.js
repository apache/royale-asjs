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

goog.provide('org.apache.flex.html.ToggleTextButton');

goog.require('org.apache.flex.html.Button');



/**
 * @constructor
 * @extends {org.apache.flex.html.Button}
 */
org.apache.flex.html.ToggleTextButton = function() {
  org.apache.flex.html.ToggleTextButton.base(this, 'constructor');



  /**
   * @private
   * @type {boolean}
   */
  this.selected_ = false;
};
goog.inherits(org.apache.flex.html.ToggleTextButton,
    org.apache.flex.html.Button);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.ToggleTextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ToggleTextButton',
                qName: 'org.apache.flex.html.ToggleTextButton'}] };


Object.defineProperties(org.apache.flex.html.ToggleTextButton.prototype, {
    /** @export */
    text: {
        /** @this {org.apache.flex.html.ToggleTextButton} */
        get: function() {
            return this.element.innerHTML;
        },
        /** @this {org.apache.flex.html.ToggleTextButton} */
        set: function(value) {
            this.element.innerHTML = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.html.ToggleTextButton} */
        get: function() {
             return this.selected_;
        },
        /** @this {org.apache.flex.html.ToggleTextButton} */
        set: function(value) {
            if (this.selected_ != value) {
              this.selected_ = value;

              var className = this.className;
              if (value) {
                 if (className.indexOf(this.SELECTED) == className.length - this.SELECTED.length)
                   this.className = className.substring(0, className.length - this.SELECTED.length);
              }
              else {
                if (className.indexOf(this.SELECTED) == -1)
                  this.className = className + this.SELECTED;
              }
           }
        }
    }
});


/**
 * @type {string} The selected setter.
 */
org.apache.flex.html.ToggleTextButton.prototype.SELECTED = '_Selected';

