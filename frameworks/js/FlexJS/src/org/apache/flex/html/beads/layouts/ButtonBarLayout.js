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

goog.provide('org_apache_flex_html_beads_layouts_ButtonBarLayout');

goog.require('org_apache_flex_core_IBeadLayout');
goog.require('org_apache_flex_html_beads_ListView');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadLayout}
 */
org_apache_flex_html_beads_layouts_ButtonBarLayout =
    function() {
  this.strand_ = null;

  this.className = 'ButtonBarLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_layouts_ButtonBarLayout
    .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBarLayout',
                qName: 'org_apache_flex_html_beads_layouts_ButtonBarLayout' }],
      interfaces: [org_apache_flex_core_IBeadLayout] };


/**
 * @expose
 * @param {Array} value A set of widths to use for each button (optional).
 */
org_apache_flex_html_beads_layouts_ButtonBarLayout.prototype.set_buttonWidths =
function(value) {
  this.buttonWidths_ = value;
};


/**
 * @expose
 * @return {Array} A set of widths to use for each button.
 */
org_apache_flex_html_beads_layouts_ButtonBarLayout.prototype.get_buttonWidths =
function() {
  return this.buttonWidths_;
};


/**
 * @expose
 * @param {Object} value The new host.
 */
org_apache_flex_html_beads_layouts_ButtonBarLayout.
    prototype.set_strand =
    function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
    this.strand_.addEventListener('childrenAdded',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('itemsCreated',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('widthChanged',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('heightChanged',
        goog.bind(this.changeHandler, this));
    this.strand_.addEventListener('sizeChanged',
        goog.bind(this.changeHandler, this));
    this.strand_.element.style.display = 'block';
  }
};


/**
 * @param {org_apache_flex_events_Event} event The text getter.
 */
org_apache_flex_html_beads_layouts_ButtonBarLayout.
    prototype.changeHandler = function(event) {

  var layoutParent = this.strand_.getBeadByType(org_apache_flex_core_ILayoutParent);
  var contentView = layoutParent.get_contentView();
  var itemRendererParent = contentView;

  var n = itemRendererParent.get_numElements();
  var xpos = 0;
  var useWidth = this.strand_.get_width() / n;
  var useHeight = this.strand_.get_height();

  for (var i = 0; i < n; i++)
  {
    var ir = itemRendererParent.getElementAt(i);
    ir.set_y(0);
    ir.set_height(useHeight);
    ir.set_x(xpos);
    ir.element.style['vertical-align'] = 'middle';
    ir.element.style['text-align'] = 'center';
    ir.element.style['left-margin'] = 'auto';
    ir.element.style['right-margin'] = 'auto';

    if (this.buttonWidths_ && !isNaN(this.buttonWidths_[i])) ir.set_width(this.buttonWidths_[i]);
    else ir.set_width(useWidth);

    if (ir.element.style.display == 'none')
      ir.lastDisplay_ = 'inline-block';
    else
      ir.element.style.display = 'inline-block';

    xpos += ir.get_width();
  }
};
