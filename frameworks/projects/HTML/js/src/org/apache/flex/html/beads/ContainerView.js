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

goog.provide('org_apache_flex_html_beads_ContainerView');

goog.require('org_apache_flex_core_BeadViewBase');
goog.require('org_apache_flex_core_IBeadLayout');
goog.require('org_apache_flex_core_ILayoutParent');



/**
 * @constructor
 * @extends {org_apache_flex_core_BeadViewBase}
 */
org_apache_flex_html_beads_ContainerView = function() {
  this.lastSelectedIndex = -1;
  org_apache_flex_html_beads_ContainerView.base(this, 'constructor');

  this.className = 'ContainerView';
};
goog.inherits(
    org_apache_flex_html_beads_ContainerView,
    org_apache_flex_core_BeadViewBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_ContainerView.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ContainerView',
                qName: 'org_apache_flex_html_beads_ContainerView' }],
    interfaces: [org_apache_flex_core_ILayoutParent]
    };


/**
 *
 */
org_apache_flex_html_beads_ContainerView.
    prototype.addOtherListeners = function() {
  this._strand.addEventListener('childrenAdded',
      goog.bind(this.changeHandler, this));
  this._strand.addEventListener('layoutNeeded',
     goog.bind(this.changeHandler, this));
  this._strand.addEventListener('itemsCreated',
     goog.bind(this.changeHandler, this));
};


/**
 * @param {org_apache_flex_events_Event} event The event.
 */
org_apache_flex_html_beads_ContainerView.
    prototype.changeHandler = function(event) {
  if (this.layout_ == null) {
    this.layout_ = this._strand.getBeadByType(org_apache_flex_core_IBeadLayout);
    if (this.layout_ == null) {
      var m3 = org_apache_flex_core_ValuesManager.valuesImpl.getValue(this._strand, 'iBeadLayout');
      this.layout_ = new m3();
      this._strand.addBead(this.layout_);
      //this.layout_.strand = this.strand_;
    }
  }
  this.layout_.layout();
  var max = this.layout_.maxWidth;
  if (isNaN(this.resizableView.explicitWidth) && !isNaN(max))
    this.resizableView.setWidth(max, true);
  max = this.layout_.maxHeight;
  if (isNaN(this.resizableView.explicitHeight) && !isNaN(max))
    this.resizableView.setHeight(max, true);
};


/**
 * @param {org_apache_flex_events_Event} event The event.
 */
org_apache_flex_html_beads_ContainerView.
    prototype.sizeChangeHandler = function(event) {
  this.addOtherListeners();
  this.changeHandler(event);
};


Object.defineProperties(org_apache_flex_html_beads_ContainerView.prototype, {
    /** @expose */
    contentView: {
        /** @this {org_apache_flex_html_beads_ContainerView} */
        get: function() {
            return this._strand;
        }
    },
    /** @expose */
    resizableView: {
        /** @this {org_apache_flex_html_beads_ContainerView} */
        get: function() {
            return this._strand;
        }
    },
    /** @expose */
    strand: {
        /** @this {org_apache_flex_html_beads_ContainerView} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(org_apache_flex_html_beads_ContainerView, this, 'strand', value);
            if (this._strand.isWidthSizedToContent() &&
                this._strand.isHeightSizedToContent())
              this.addOtherListeners();
            else {
              this._strand.addEventListener('heightChanged',
                  goog.bind(this.changeHandler, this));
              this._strand.addEventListener('widthChanged',
                  goog.bind(this.changeHandler, this));
              this._strand.addEventListener('sizeChanged',
                  goog.bind(this.sizeChangeHandler, this));
              if (!isNaN(this._strand.explicitWidth) &&
                  !isNaN(this._strand.explicitHeight))
                this.addOtherListeners();
            }
         }
    }

});
