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

goog.provide('org_apache_flex_html_beads_PanelView');

goog.require('org_apache_flex_html_beads_ContainerView');



/**
 * @constructor
 */
org_apache_flex_html_beads_PanelView = function() {
  org_apache_flex_html_beads_PanelView.base(this, 'constructor');
  /**
   * @private
   * @type {boolean}
  */
  this.titleBarAdded_ = false;

  /**
   * @private
   * @type {?Object}
  */
  this.titleBar_ = null;
};
goog.inherits(
    org_apache_flex_html_beads_PanelView,
    org_apache_flex_html_beads_ContainerView);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_PanelView
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'PanelView',
                qName: 'org_apache_flex_html_beads_PanelView'}]};


Object.defineProperties(org_apache_flex_html_beads_PanelView.prototype, {
    /** @export */
    contentView: {
        /** @this {org_apache_flex_html_beads_ContainerView} */
        get: function() {
            return this._strand.contentArea;
        }
    },
    /** @export */
    strand: {
        /** @this {org_apache_flex_html_beads_PanelView} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(org_apache_flex_html_beads_PanelView, this, 'strand', value);

            if (!this.titleBar_)
              this.titleBar_ = new org_apache_flex_html_TitleBar();

            this._strand.titleBar = this.titleBar_;
            this.titleBar_.id = 'titleBar';
            this.titleBar_.model = this._strand.model;

            this._strand.controlBar =
                new org_apache_flex_html_ControlBar();

            // listen for changes to the strand's model so items can be changed
            // in the view
            this._strand.model.addEventListener('titleChange',
                goog.bind(this.changeHandler, this));
        }
    },
    /** @export */
    titleBar: {
        /** @this {org_apache_flex_html_beads_PanelView} */
        get: function() {
            return this.titleBar_;
        },
        /** @this {org_apache_flex_html_beads_PanelView} */
        set: function(value) {
            this.titleBar_ = value;
        }
    }
});


/**
 * @override
 * @param {Object} event The event that triggered this handler.
 */
org_apache_flex_html_beads_PanelView.prototype.changeHandler =
    function(event) {
  var strand = this._strand;
  if (!this.titleBarAdded_)
  {
    this.titleBarAdded_ = true;
    strand.addElement(this.titleBar_);
    if (strand.controlBar != null)
      strand.addElement(strand.controlBar);
  }

  if (event.type == 'titleChange') {
    this.titleBar_.title = strand.model.title;
  }

  var p = this._strand.positioner;
  if (!strand.isWidthSizedToContent()) {
    var w = strand.width;
    w -= p.offsetWidth - p.clientWidth;
    this.titleBar_.setWidth(w);
    strand.contentArea.style.width = w.toString() + 'px';
    if (strand.controlBar)
      strand.controlBar.setWidth(w);
  }
  if (!strand.isHeightSizedToContent()) {
    var t = this.titleBar_.height;
    var b = 0;
    if (strand.controlBar)
      b = strand.controlBar.height;
    strand.contentArea.style.top = t.toString() + 'px';
    var h = strand.height - t - b;
    h -= p.offsetHeight - p.clientHeight;
    strand.contentArea.style.height = h.toString() + 'px';
  }
  org_apache_flex_html_beads_PanelView.base(this, 'changeHandler', event);
};
