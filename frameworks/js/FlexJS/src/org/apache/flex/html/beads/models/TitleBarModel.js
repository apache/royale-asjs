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

goog.provide('org_apache_flex_html_beads_models_TitleBarModel');

goog.require('org_apache_flex_core_IBeadModel');
goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @implements {org_apache_flex_core_IBeadModel}
 */
org_apache_flex_html_beads_models_TitleBarModel = function() {
  org_apache_flex_html_beads_models_TitleBarModel.base(this, 'constructor');

  /**
   * @private
   * @type {string}
   */
  this.title_ = '';
  /**
   * @private
   * @type {string}
   */
  this.htmlTitle_ = '';
  /**
   * @private
   * @type {boolean}
   */
  this.showCloseButton_ = false;
};
goog.inherits(org_apache_flex_html_beads_models_TitleBarModel,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_models_TitleBarModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'RangeModel',
                qName: 'org_apache_flex_html_beads_models_TitleBarModel'}],
      interfaces: [org_apache_flex_core_IBeadModel]
    };


Object.defineProperties(org_apache_flex_html_beads_models_TitleBarModel.prototype, {
    'strand': {
        /** @this {org_apache_flex_html_beads_models_TitleBarModel} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    'title': {
        /** @this {org_apache_flex_html_beads_models_TitleBarModel} */
        get: function() {
            return this.title_;
        },
        /** @this {org_apache_flex_html_beads_models_TitleBarModel} */
        set: function(value) {
            if (this.title_ != value) {
              this.title_ = value;
              this.dispatchEvent('titleChange');
            }
        }
    },
    'htmlTitle': {
        /** @this {org_apache_flex_html_beads_models_TitleBarModel} */
        get: function() {
            return this.htmlTitle_;
        },
        /** @this {org_apache_flex_html_beads_models_TitleBarModel} */
        set: function(value) {
            if (this.htmlTitle_ != value) {
              this.htmlTitle_ = value;
              this.dispatchEvent('htmlTitleChange');
            }
        }
    },
    'showCloseButton': {
        /** @this {org_apache_flex_html_beads_models_TitleBarModel} */
        get: function() {
            return this.showCloseButton_;
        },
        /** @this {org_apache_flex_html_beads_models_TitleBarModel} */
        set: function(value) {
            if (this.showCloseButton_ != value) {
              this.showCloseButton_ = value;
              this.dispatchEvent('showCloseButtonChange');
            }
        }
    }
});
