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

goog.provide('org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout');

goog.require('org_apache_flex_core_IBeadLayout');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadLayout}
 */
org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout =
    function() {
  this.strand_ = null;
  this.className = 'NonVirtualHorizontalLayout';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NonVirtualHorizontalLayout',
                qName: 'org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout' }],
      interfaces: [org_apache_flex_core_IBeadLayout] };


Object.defineProperties(org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
              if (this.strand_.isWidthSizedToContent() &&
                  this.strand_.isHeightSizedToContent())
                this.addOtherListeners();
              else {
                this.strand_.addEventListener('heightChanged',
                    goog.bind(this.changeHandler, this));
                this.strand_.addEventListener('widthChanged',
                    goog.bind(this.changeHandler, this));
                this.strand_.addEventListener('sizeChanged',
                    goog.bind(this.sizeChangeHandler, this));
                if (!isNaN(this.strand_.explicitWidth) &&
                    !isNaN(this.strand_.explicitHeight))
                    this.addOtherListeners();
              }
              this.strand_.element.style.display = 'block';
            }
        }
    }
});


/**
 *
 */
org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout.
    prototype.addOtherListeners = function() {
  this.strand_.addEventListener('childrenAdded',
      goog.bind(this.changeHandler, this));
  this.strand_.addEventListener('layoutNeeded',
     goog.bind(this.changeHandler, this));
  this.strand_.addEventListener('itemsCreated',
     goog.bind(this.changeHandler, this));
};


/**
 * @param {org_apache_flex_events_Event} event The event.
 */
org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout.
    prototype.sizeChangeHandler = function(event) {
  this.addOtherListeners();
  this.changeHandler(event);
};


/**
 * @param {org_apache_flex_events_Event} event The text getter.
 */
org_apache_flex_html_beads_layouts_NonVirtualHorizontalLayout.
    prototype.changeHandler = function(event) {
  var children, i, n;

  children = this.strand_.internalChildren();
  n = children.length;
  for (i = 0; i < n; i++)
  {
    var child = children[i];
    child.internalDisplay = 'inline-block';
    if (child.style.display == 'none')
      child.lastDisplay_ = 'inline-block';
    else
      child.style.display = 'inline-block';
    child.style.verticalAlign = 'middle';
    child.flexjs_wrapper.dispatchEvent('sizeChanged');
  }
};
