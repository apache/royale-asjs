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

goog.require('org.apache.flex.html.TitleBar');
goog.require('org.apache.flex.html.beads.ContainerView');
goog.require('org.apache.flex.utils.CSSContainerUtils');



/**
 * @constructor
 * @extends {org.apache.flex.html.beads.ContainerView}
 */
org.apache.flex.html.beads.PanelView = function() {
  org.apache.flex.html.beads.PanelView.base(this, 'constructor');
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

  this.className = 'PanelView';
};
goog.inherits(
    org.apache.flex.html.beads.PanelView,
    org.apache.flex.html.beads.ContainerView);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.PanelView
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'PanelView',
                qName: 'org.apache.flex.html.beads.PanelView'}]};


/**
 * @override
 */
org.apache.flex.html.beads.PanelView.
    prototype.completeSetup = function() {
  org.apache.flex.html.beads.PanelView.base(this, 'completeSetup');
  // listen for changes to the strand's model so items can be changed
  // in the view
  this._strand.model.addEventListener('titleChange',
      goog.bind(this.changeHandler, this));
};


Object.defineProperties(org.apache.flex.html.beads.PanelView.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.PanelView} */
        set: function(value) {
            if (!this.titleBar_)
              this.titleBar_ = new org.apache.flex.html.TitleBar();

            value.titleBar = this.titleBar_;
            this.titleBar_.id = 'panelTitleBar';
            this.titleBar_.model = value.model;
            this.titleBarAdded_ = true;
            value.addElement(this.titleBar_);

//            this._strand.controlBar =
//                new org.apache.flex.html.ControlBar();

            org.apache.flex.utils.Language.superSetter(org.apache.flex.html.beads.PanelView, this, 'strand', value);
        }
    },
    /** @export */
    titleBar: {
        /** @this {org.apache.flex.html.beads.PanelView} */
        get: function() {
            return this.titleBar_;
        },
        /** @this {org.apache.flex.html.beads.PanelView} */
        set: function(value) {
            this.titleBar_ = value;
        }
    }
});


/**
 * @override
 */
org.apache.flex.html.beads.PanelView.
    prototype.layoutViewBeforeContentLayout = function() {
  var vm = this.viewportModel;
  var host = this._strand;
  var w = host.width;
  var s = window.getComputedStyle(host.element);
  var sw = Number(s.width.substring(0, s.width.length - 2));
  if (sw > w) w = sw;
  vm.borderMetrics = org.apache.flex.utils.CSSContainerUtils.getBorderMetrics(host);
  this.titleBar.x = 0;
  this.titleBar.y = 0;
  if (!host.isWidthSizedToContent())
    this.titleBar.width = w - vm.borderMetrics.left - vm.borderMetrics.right;
  vm.chromeMetrics = this.getChromeMetrics();
  this.viewport.setPosition(vm.chromeMetrics.left,
                            vm.chromeMetrics.top);
  this.viewport.layoutViewportBeforeContentLayout(
      !host.isWidthSizedToContent() ?
          w - vm.borderMetrics.left - vm.borderMetrics.right -
                       vm.chromeMetrics.left - vm.chromeMetrics.right : NaN,
      !host.isHeightSizedToContent() ?
          host.height - vm.borderMetrics.top - vm.borderMetrics.bottom -
                        vm.chromeMetrics.top - vm.chromeMetrics.bottom : NaN);
};


/**
 * @override
 */
org.apache.flex.html.beads.PanelView.
    prototype.layoutViewAfterContentLayout = function() {
  var vm = this.viewportModel;
  var host = this._strand;
  var viewportSize = this.viewport.layoutViewportAfterContentLayout();
  var hasWidth = !host.isWidthSizedToContent();
  var hasHeight = !host.isHeightSizedToContent();
  if (!hasWidth) {
    this.titleBar.width = viewportSize.width; // should get titlebar to layout and get new height
    vm.chromeMetrics = this.getChromeMetrics();
  }
  org.apache.flex.html.beads.PanelView.base(this, 'layoutViewAfterContentLayout');
};


/**
 * @override
 * Returns the chrome metrics
 */
org.apache.flex.html.beads.PanelView.
    prototype.getChromeMetrics = function() {
  return new org.apache.flex.geom.Rectangle(0, this.titleBar.height, 0, 0 - this.titleBar.height);
};




/**
 * @override
 * @param {org.apache.flex.events.Event} event The event that triggered this handler.
 */
/**org.apache.flex.html.beads.PanelView.prototype.changeHandler =
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
  org.apache.flex.html.beads.PanelView.base(this, 'changeHandler', event);
};**/
