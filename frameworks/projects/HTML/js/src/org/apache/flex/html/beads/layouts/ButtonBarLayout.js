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

goog.provide('org.apache.flex.html.beads.layouts.ButtonBarLayout');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.html.beads.ListView');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadLayout}
 */
org.apache.flex.html.beads.layouts.ButtonBarLayout =
    function() {
  this.strand_ = null;

  this.className = 'ButtonBarLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.layouts.ButtonBarLayout
    .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ButtonBarLayout',
                qName: 'org.apache.flex.html.beads.layouts.ButtonBarLayout' }],
      interfaces: [org.apache.flex.core.IBeadLayout] };


Object.defineProperties(org.apache.flex.html.beads.layouts.ButtonBarLayout.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.layouts.ButtonBarLayout} */
        set: function(value) {
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
        }
    },
    /** @export */
    buttonWidths: {
        /** @this {org.apache.flex.html.beads.layouts.ButtonBarLayout} */
        set: function(value) {
            this.buttonWidths_ = value;
        },
        /** @this {org.apache.flex.html.beads.layouts.ButtonBarLayout} */
        get: function() {
            return this.buttonWidths_;
        }
    }
});


/**
 * @param {org.apache.flex.events.Event} event The text getter.
 */
org.apache.flex.html.beads.layouts.ButtonBarLayout.
    prototype.changeHandler = function(event) {

  var layoutParent = this.strand_.getBeadByType(org.apache.flex.core.ILayoutParent);
  var contentView = layoutParent.contentView;
  var itemRendererParent = contentView;

  var n = itemRendererParent.numElements;
  var xpos = 0;
  var useWidth = this.strand_.width / n;
  var useHeight = this.strand_.height;

  for (var i = 0; i < n; i++)
  {
    var ir = itemRendererParent.getElementAt(i);
    ir.y = 0;
    ir.height = useHeight;
    ir.x = xpos;
    ir.element.internalDisplay = 'inline-block';
    ir.element.style['vertical-align'] = 'middle';
    ir.element.style['text-align'] = 'center';
    ir.element.style['left-margin'] = 'auto';
    ir.element.style['right-margin'] = 'auto';

    if (this.buttonWidths_ && !isNaN(this.buttonWidths_[i])) ir.width = this.buttonWidths_[i];
    else ir.width = useWidth;

    if (ir.element.style.display == 'none')
      ir.lastDisplay_ = 'inline-block';
    else
      ir.element.style.display = 'inline-block';

    xpos += ir.width;
  }
};
