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

goog.provide('org.apache.flex.html.beads.PanelView');

goog.require('org.apache.flex.core.IBeadView');



/**
 * @constructor
 */
org.apache.flex.html.beads.PanelView = function() {
  /**
   * @private
   * @type {boolean}
  */
  this.titleBarAdded_ = false;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.PanelView
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'PanelView',
                qName: 'org.apache.flex.html.beads.PanelView'}],
      interfaces: [org.apache.flex.core.IBeadView] };


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.beads.PanelView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  if (!this.titleBar)
    this.strand_.titleBar = new org.apache.flex.html.TitleBar();
  else
    this.strand_.titleBar = this.titleBar;

  this.strand_.titleBar.set_id('titleBar');
  this.strand_.titleBar.set_model(this.strand_.get_model());

  this.strand_.controlBar =
      new org.apache.flex.html.ControlBar();

  this.strand_.addEventListener('childrenAdded',
      goog.bind(this.changeHandler, this));

  // listen for changes to the strand's model so items can be changed
  // in the view
  this.strand_.model.addEventListener('titleChange',
      goog.bind(this.changeHandler, this));

};


/**
 * @param {Object} event The event that triggered this handler.
 */
org.apache.flex.html.beads.PanelView.prototype.changeHandler =
    function(event) {
  var strand = this.strand_;
  if (!this.titleBarAdded_)
  {
    this.titleBarAdded_ = true;
    strand.addElement(strand.titleBar);
    strand.addElement(strand.controlBar);
  }

  if (event.type == 'titleChange') {
    strand.titleBar.set_title(strand.model.get_title());
  }

  var p = this.strand_.positioner;
  if (!strand.isWidthSizedToContent()) {
    var w = strand.get_width();
    w -= p.offsetWidth - p.clientWidth;
    strand.titleBar.setWidth(w);
    strand.contentArea.style.width = w.toString() + 'px';
    if (strand.controlBar)
      strand.controlBar.setWidth(w);
  }
  if (!strand.isHeightSizedToContent()) {
    var t = strand.titleBar.get_height();
    var b = 0;
    if (strand.controlBar)
      b = strand.controlBar.get_height();
    strand.contentArea.style.top = t.toString() + 'px';
    var h = strand.get_height() - t - b;
    h -= p.offsetHeight - p.clientHeight;
    strand.contentArea.style.height = h.toString() + 'px';
  }
  this.strand_.dispatchEvent('layoutNeeded');
};
