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

goog.provide('org.apache.flex.html.beads.ButtonBarView');

goog.require('org.apache.flex.html.beads.ListView');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.html.beads.ListView}
 */
org.apache.flex.html.beads.ButtonBarView = function() {
  this.lastSelectedIndex = -1;
  org.apache.flex.html.beads.ButtonBarView.base(this, 'constructor');

  this.className = 'ButtonBarView';
};
goog.inherits(
    org.apache.flex.html.beads.ButtonBarView,
    org.apache.flex.html.beads.ListView);


/**
 * @override
 */
org.apache.flex.html.beads.ButtonBarView.
    prototype.layoutViewBeforeContentLayout = function() {
  var host = this._strand;
  var vm = this.viewportModel;
  vm.borderMetrics = org.apache.flex.utils.CSSContainerUtils.getBorderMetrics(host);
  vm.chromeMetrics = this.getChromeMetrics();
  this.viewport.setPosition(0, 0);
  this.viewport.layoutViewportBeforeContentLayout(host.width, host.height);
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.ButtonBarView.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBarView',
                qName: 'org.apache.flex.html.beads.ButtonBarView' }] };


Object.defineProperties(org.apache.flex.html.beads.ButtonBarView.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.ButtonBarView} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(
                org.apache.flex.html.beads.ButtonBarView, this, 'strand', value);
        }
    }
});
