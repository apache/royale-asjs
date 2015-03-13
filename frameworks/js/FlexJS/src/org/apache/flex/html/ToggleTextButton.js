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

goog.provide('org_apache_flex_html_ToggleTextButton');

goog.require('org_apache_flex_html_Button');



/**
 * @constructor
 * @extends {org_apache_flex_html_Button}
 */
org_apache_flex_html_ToggleTextButton = function() {
  org_apache_flex_html_ToggleTextButton.base(this, 'constructor');



  /**
   * @private
   * @type {boolean}
   */
  this.selected_ = false;
};
goog.inherits(org_apache_flex_html_ToggleTextButton,
    org_apache_flex_html_Button);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_ToggleTextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ToggleTextButton',
                qName: 'org_apache_flex_html_ToggleTextButton'}] };


Object.defineProperties(org_apache_flex_html_TextButton.prototype, {
    'text': {
		get: function() {
            return this.element.innerHTML;
		},
        set: function(value) {
            this.element.innerHTML = value;
		}
	},
    'selected': {
		get: function() {
             return this.selected_;
		},
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
org_apache_flex_html_ToggleTextButton.prototype.SELECTED = '_Selected';

