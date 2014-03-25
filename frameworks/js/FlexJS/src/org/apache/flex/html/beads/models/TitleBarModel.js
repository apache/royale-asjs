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

goog.provide('org.apache.flex.html.staticControls.beads.models.TitleBarModel');

goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel = function() {
  goog.base(this);

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
goog.inherits(org.apache.flex.html.staticControls.beads.models.TitleBarModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'RangeModel',
                qName: 'org.apache.flex.html.staticControls.beads.models.TitleBarModel'}] };


/**
 * @expose
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.
    set_strand = function(value) {
  this.strand_ = value;
};


/**
 * @expose
 * @return {string} The title.
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.
    get_title = function() {
  return this.title_;
};


/**
 * @expose
 * @param {string} value The title to set.
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.
    set_title = function(value) {
  if (this.title_ != value) {
    this.title_ = value;
    this.dispatchEvent('titleChange');
  }
};


/**
 * @expose
 * @return {string} The HTML title.
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.
    get_htmlTitle = function() {
  return this.htmlTitle_;
};


/**
 * @expose
 * @param {string} value The new HTML title.
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.
    set_htmlTitle = function(value) {
  if (this.htmlTitle_ != value) {
    this.htmlTitle_ = value;
    this.dispatchEvent('htmlTitleChange');
  }
};


/**
 * @expose
 * @return {boolean} Returns true if the close button should appear in
 * the TitleBar.
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.
    get_showCloseButton = function() {
  return this.showCloseButton_;
};


/**
 * @expose
 * @param {boolean} value Determines if the close button shows (true) or
 * not (false).
 */
org.apache.flex.html.staticControls.beads.models.TitleBarModel.prototype.
    set_showCloseButton = function(value) {
  if (this.showCloseButton_ != value) {
    this.showCloseButton_ = value;
    this.dispatchEvent('showCloseButtonChange');
  }
};
