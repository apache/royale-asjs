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

goog.provide('org.apache.flex.html.beads.ScrollingContainerView');

goog.require('org.apache.flex.html.beads.ContainerView');



/**
 * @constructor
 * @extends {org.apache.flex.html.beads.ContainerView}
 */
org.apache.flex.html.beads.ScrollingContainerView = function() {
  this.lastSelectedIndex = -1;
  org.apache.flex.html.beads.ScrollingContainerView.base(this, 'constructor');

  this.className = 'ScrollingContainerView';
};
goog.inherits(
    org.apache.flex.html.beads.ScrollingContainerView,
    org.apache.flex.html.beads.ContainerView);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.ScrollingContainerView.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ScrollingContainerView',
                qName: 'org.apache.flex.html.beads.ScrollingContainerView' }],
    interfaces: [org.apache.flex.core.ILayoutParent]
    };


/**
 * @expose
 * @return {Object} value The content view.
 */
org.apache.flex.html.beads.ScrollingContainerView.prototype.get_contentView =
    function() {

  return this._strand;
};


/**
 * @expose
 * @return {Object} value The resizeable view.
 */
org.apache.flex.html.beads.ScrollingContainerView.prototype.get_resizableView =
function() {

  return this._strand;
};


/**
 * @expose
 * @return {Object} value The resizeable view.
 */
org.apache.flex.html.beads.ScrollingContainerView.prototype.get_verticalScrollPosition =
function() {

  return this._strand.scrollTop;
};


/**
 * @expose
 * @return {Object} value The resizeable view.
 */
org.apache.flex.html.beads.ScrollingContainerView.prototype.get_maxVerticalScrollPosition =
function() {

  return this._strand.scrollHeight - this._strand.clientHeight;
};
