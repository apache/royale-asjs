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

goog.provide('org.apache.flex.html.beads.layouts.NonVirtualVerticalScrollingLayout');

goog.require('org.apache.flex.core.IBeadLayout');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.
    NonVirtualVerticalScrollingLayout = function() {
  this.strand_ = null;
  this.className = 'NonVirtualVerticalScrollingLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.
    NonVirtualVerticalScrollingLayout.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NonVirtualVerticalScrollingLayout',
                qName: 'org.apache.flex.html.beads.layouts.NonVirtualVerticalScrollingLayout' }],
      interfaces: [org.apache.flex.core.IBeadLayout] };


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.beads.layouts.
    NonVirtualVerticalScrollingLayout.prototype.set_strand = function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('childrenAdded',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('layoutNeeded',
        goog.bind(this.changeHandler, this));
  }
};


/**
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.beads.layouts.
    NonVirtualVerticalScrollingLayout.prototype.changeHandler =
        function(event) {
  var layoutParent = this.strand_.getBeadByType(org.apache.flex.core.ILayoutParent);
  var contentView = layoutParent.get_contentView();
  var selectionModel = this.strand_.get_model();
  var dp = selectionModel.get_dataProvider();

  var itemRendererFactory = this.strand_.getBeadByType(org.apache.flex.core.IItemRendererClassFactory);

  var n = dp.length;
  var yy = 0;
  var defaultWidth = contentView.get_width();

  for (var i = 0; i < n; i++)
  {
    var ir = contentView.getItemRendererForIndex(i);
    if (ir == null) {
      ir = itemRendererFactory.createItemRenderer(contentView);
    }
    ir.set_index(i);
    ir.set_labelField(this.strand_.get_labelField());
    ir.set_y(yy);
    ir.set_x(0);
    ir.set_width(defaultWidth);
    ir.set_data(dp[i]);
    yy += ir.get_height();
  }
};
