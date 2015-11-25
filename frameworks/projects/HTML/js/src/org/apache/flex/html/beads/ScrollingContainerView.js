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
    interfaces: [org.apache.flex.core.ILayoutHost]
    };


Object.defineProperties(org.apache.flex.html.beads.ScrollingContainerView.prototype, {
    /** @export */
    contentView: {
        /** @this {org.apache.flex.html.beads.ScrollingContainerView} */
        get: function() {
            return this._strand;
        }
    },
    /** @export */
    resizableView: {
        /** @this {org.apache.flex.html.beads.ScrollingContainerView} */
        get: function() {
            return this._strand;
        }
    },
    /** @export */
    verticalScrollPosition: {
        /** @this {org.apache.flex.html.beads.ScrollingContainerView} */
        get: function() {
           return this._strand.scrollTop;
        },
        /** @this {org.apache.flex.html.beads.ScrollingContainerView} */
        set: function(value) {
           this._strand.scrollTop = value;
        }
    },
    /** @export */
    maxVerticalScrollPosition: {
        /** @this {org.apache.flex.html.beads.ScrollingContainerView} */
        get: function() {
            return this._strand.scrollHeight - this._strand.clientHeight;
        }
    }
});
