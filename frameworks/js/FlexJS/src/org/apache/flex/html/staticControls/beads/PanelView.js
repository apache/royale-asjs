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

goog.provide('org.apache.flex.html.staticControls.beads.PanelView');



/**
 * @constructor
 */
org.apache.flex.html.staticControls.beads.PanelView = function() {
  
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.PanelView}
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.PanelView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  this.strand_.titleBar = new org.apache.flex.html.staticControls.TitleBar();
  this.strand_.titleBar.addedToParent();
  this.strand_.titleBar.element.id = 'titleBar';
  this.strand_.addElement(this.strand_.titleBar);

  this.strand_.controlBar = new org.apache.flex.html.staticControls.ControlBar();
  this.strand_.addElement(this.strand_.controlBar);

  // listen for changes to the strand's model so items can be changed in the view
  this.strand_.model_.addEventListener('titleChange',goog.bind(this.changeHandler, this));

};

/**
 * @private
 * @this {org.apache.flex.html.staticControls.beads.PanelView}
 * @param {Object} event The event that triggered this handler.
 */
org.apache.flex.html.staticControls.beads.PanelView.prototype.changeHandler =
  function(event) {
    if (event.type == 'titleChange') {
      this.strand_.titleBar.set_title(this.strand_.model_.get_title());
    }
};