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

goog.provide('org_apache_flex_html_beads_ScrollingContainerView');

goog.require('org_apache_flex_html_beads_ContainerView');



/**
 * @constructor
 * @extends {org_apache_flex_html_beads_ContainerView}
 */
org_apache_flex_html_beads_ScrollingContainerView = function() {
  this.lastSelectedIndex = -1;
  org_apache_flex_html_beads_ScrollingContainerView.base(this, 'constructor');

  this.className = 'ScrollingContainerView';
};
goog.inherits(
    org_apache_flex_html_beads_ScrollingContainerView,
    org_apache_flex_html_beads_ContainerView);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_ScrollingContainerView.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ScrollingContainerView',
                qName: 'org_apache_flex_html_beads_ScrollingContainerView' }],
    interfaces: [org_apache_flex_core_ILayoutParent]
    };


/**
 * @expose
 * @return {Object} value The content view.
 */
org_apache_flex_html_beads_ScrollingContainerView.prototype.get_contentView =
    function() {

  return this._strand;
};


/**
 * @expose
 * @return {Object} value The resizeable view.
 */
org_apache_flex_html_beads_ScrollingContainerView.prototype.get_resizableView =
function() {

  return this._strand;
};


/**
 * @expose
 * @return {number} value The resizeable view.
 */
org_apache_flex_html_beads_ScrollingContainerView.prototype.get_verticalScrollPosition =
function() {

  return this._strand.scrollTop;
};


/**
 * @expose
 * @param {number} value The resizeable view.
 */
org_apache_flex_html_beads_ScrollingContainerView.prototype.set_verticalScrollPosition =
function(value) {

  this._strand.scrollTop = value;
};


/**
 * @expose
 * @return {number} value The resizeable view.
 */
org_apache_flex_html_beads_ScrollingContainerView.prototype.get_maxVerticalScrollPosition =
function() {

  return this._strand.scrollHeight - this._strand.clientHeight;
};
