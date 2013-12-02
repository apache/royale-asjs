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

goog.provide('org.apache.flex.html.staticControls.beads.IListView');

goog.require('org.apache.flex.html.staticControls.supportClasses.Border');
goog.require('org.apache.flex.html.staticControls.supportClasses.ScrollBar');



/**
 * @interface
 * @extends {org.apache.flex.core.IBeadView}
 */
org.apache.flex.html.staticControls.beads.IListView = function() {
};
org.apache.flex.html.staticControls.beads.IListView.prototype.border;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.IListView.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'IListView',
            qName: 'org.apache.flex.html.staticControls.beads.IListView'}],
  interfaces: [org.apache.flex.core.IBeadView] };
