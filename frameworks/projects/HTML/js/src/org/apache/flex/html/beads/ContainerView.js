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

goog.provide('org.apache.flex.html.beads.ContainerView');

goog.require('org.apache.flex.core.BeadViewBase');
goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.core.ILayoutParent');
goog.require('org.apache.flex.core.IViewport');
goog.require('org.apache.flex.core.IViewportModel');
goog.require('org.apache.flex.geom.Rectangle');
goog.require('org.apache.flex.utils.CSSContainerUtils');



/**
 * @constructor
 * @extends {org.apache.flex.core.BeadViewBase}
 */
org.apache.flex.html.beads.ContainerView = function() {
  this.lastSelectedIndex = -1;
  org.apache.flex.html.beads.ContainerView.base(this, 'constructor');

  this.className = 'ContainerView';
  this.runningLayout = false;
};
goog.inherits(
    org.apache.flex.html.beads.ContainerView,
    org.apache.flex.core.BeadViewBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.ContainerView.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ContainerView',
                qName: 'org.apache.flex.html.beads.ContainerView' }],
    interfaces: [org.apache.flex.core.ILayoutParent]
    };


/**
 * @private
 * @type {Object}
 */
org.apache.flex.html.beads.ContainerView.prototype.viewport_ = null;


/**
 * @private
 * @type {Object}
 */
org.apache.flex.html.beads.ContainerView.prototype.viewportModel_ = null;


/**
 * @private
 * @type {Object}
 */
org.apache.flex.html.beads.ContainerView.prototype.contentArea_ = null;


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.initCompleteHandler = function(event) {
  if ((this.host.isHeightSizedToContent() || !isNaN(this.host.explicitHeight)) &&
      (this.host.isWidthSizedToContent() || !isNaN(this.host.explicitWidth))) {
         this.completeSetup();

         var num = this.contentView.numElements;
         // make sure there are children AND you are in the DOM before laying out.
         // If not in the DOM, you'll get funky numbers
         if (num > 0 && document.body.contains(this.host.element)) {
           this.performLayout(event);
         }
   }
   else {
     this._strand.addEventListener('sizeChanged',
       org.apache.flex.utils.Language.closure(this.deferredSizeHandler, this, 'deferredSizeHandler'));
     this._strand.addEventListener('widthChanged',
       org.apache.flex.utils.Language.closure(this.deferredSizeHandler, this, 'deferredSizeHandler'));
     this._strand.addEventListener('heightChanged',
       org.apache.flex.utils.Language.closure(this.deferredSizeHandler, this, 'deferredSizeHandler'));
   }
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.deferredSizeHandler = function(event) {
    this._strand.removeEventListener('sizeChanged',
      org.apache.flex.utils.Language.closure(this.deferredSizeHandler, this, 'deferredSizeHandler'));
    this._strand.removeEventListener('widthChanged',
      org.apache.flex.utils.Language.closure(this.deferredSizeHandler, this, 'deferredSizeHandler'));
    this._strand.removeEventListener('heightChanged',
      org.apache.flex.utils.Language.closure(this.deferredSizeHandler, this, 'deferredSizeHandler'));
    this.completeSetup();

    var num = this.contentView.numElements;
    if (num > 0) {
      this.performLayout(event);
    }
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.changeHandler = function(event) {
  this.performLayout(event);
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.childrenChangedHandler = function(event) {
    var num = this.contentView.numElements;
    for (var i = 0; i < num; i++) {
      var child = this.contentView.getElementAt(i);
      child.addEventListener('widthChanged',
          org.apache.flex.utils.Language.closure(this.childResizeHandler, this, 'childResizeHandler'));
      child.addEventListener('heightChanged',
          org.apache.flex.utils.Language.closure(this.childResizeHandler, this, 'childResizeHandler'));
    }
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.sizeChangeHandler = function(event) {
  if (this.runningLayout) return;
  this.performLayout(event);
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.resizeHandler = function(event) {
  if (this.runningLayout) return;
  this.performLayout(event);
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
 org.apache.flex.html.beads.ContainerView.
    prototype.childResizeHandler = function(event) {
  if (this.runningLayout) return;
  this.performLayout(event);
};


/**
 *
 */
org.apache.flex.html.beads.ContainerView.
    prototype.completeSetup = function() {
  this.createViewport();

  this._strand.addEventListener('childrenAdded',
      org.apache.flex.utils.Language.closure(this.childrenChangedHandler, this, 'childrenChangedHandler'));
  this.childrenChangedHandler(null);
  this._strand.addEventListener('childrenAdded',
      org.apache.flex.utils.Language.closure(this.changeHandler, this, 'changeHandler'));
  this._strand.addEventListener('childrenRemoved',
      org.apache.flex.utils.Language.closure(this.changeHandler, this, 'changeHandler'));
  this._strand.addEventListener('layoutNeeded',
     org.apache.flex.utils.Language.closure(this.performLayout, this, 'performLayout'));
  this._strand.addEventListener('widthChanged',
     org.apache.flex.utils.Language.closure(this.resizeHandler, this, 'resizeHandler'));
  this._strand.addEventListener('heightChanged',
     org.apache.flex.utils.Language.closure(this.resizeHandler, this, 'resizeHandler'));
  this._strand.addEventListener('sizeChanged',
     org.apache.flex.utils.Language.closure(this.resizeHandler, this, 'resizeHandler'));
};


/**
 * Calculate the space taken up by non-content children like a TItleBar in a Panel.
 * @return {org.apache.flex.geom.Rectangle} The space.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.getChromeMetrics = function() {
  return new org.apache.flex.geom.Rectangle(0, 0, 0, 0);
};


/**
 * Creates the viewport and viewportModel.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.createViewport = function() {
  this.viewportModel = this._strand.getBeadByType(org.apache.flex.core.IViewportModel);
  if (this.viewportModel == null) {
    var m3 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this._strand, 'iViewportModel');
    this.viewportModel = new m3();
    this._strand.addBead(this.viewportModel);
  }
  this.viewport = this._strand.getBeadByType(org.apache.flex.core.IViewport);
  if (this.viewport == null) {
    var m2 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this._strand, 'iViewport');
    this.viewport = new m2();
    this._strand.addBead(this.viewport);
  }
};


/**
 *
 */
org.apache.flex.html.beads.ContainerView.
    prototype.layoutViewBeforeContentLayout = function() {
  var host = this._strand;
  var vm = this.viewportModel;
  vm.borderMetrics = org.apache.flex.utils.CSSContainerUtils.getBorderMetrics(host);
  vm.chromeMetrics = this.getChromeMetrics();
  this.viewport.setPosition(vm.borderMetrics.left + vm.chromeMetrics.left,
                            vm.borderMetrics.top + vm.chromeMetrics.top);
  this.viewport.layoutViewportBeforeContentLayout(
      !host.isWidthSizedToContent() ?
          host.width - vm.borderMetrics.left - vm.borderMetrics.right -
                     vm.chromeMetrics.left - vm.chromeMetrics.right - 1 : NaN,
      !host.isHeightSizedToContent() ?
          host.height - vm.borderMetrics.top - vm.borderMetrics.bottom -
                     vm.chromeMetrics.top - vm.chromeMetrics.bottom - 1 : NaN);
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.performLayout = function(event) {
  this.runningLayout = true;
  this.layoutViewBeforeContentLayout();
  if (this.layout == null) {
    this.layout = this._strand.getBeadByType(org.apache.flex.core.IBeadLayout);
    if (this.layout == null) {
      var m3 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this._strand, 'iBeadLayout');
      this.layout = new m3();
      this._strand.addBead(this.layout);
    }
  }
  this.layout.layout();

  this.layoutViewAfterContentLayout();
  this.runningLayout = false;
};


/**
 *
 */
org.apache.flex.html.beads.ContainerView.
    prototype.layoutViewAfterContentLayout = function() {
  var host = this._strand;

  var viewportSize = this.viewport.layoutViewportAfterContentLayout();
  var vm = this.viewportModel;

  if (host.isWidthSizedToContent() && host.isHeightSizedToContent()) {
    host.setWidthAndHeight(viewportSize.width + vm.borderMetrics.left + vm.borderMetrics.right +
                               vm.chromeMetrics.left + vm.chromeMetrics.right + 1,
                           viewportSize.height + vm.borderMetrics.top + vm.borderMetrics.bottom +
                               vm.chromeMetrics.top + vm.chromeMetrics.bottom + 1, false);
  }
  else if (!host.isWidthSizedToContent() && host.isHeightSizedToContent()) {
    host.setHeight(viewportSize.height + vm.borderMetrics.top + vm.borderMetrics.bottom +
                               vm.chromeMetrics.top + vm.chromeMetrics.bottom + 1, false);
  }
  else if (host.isWidthSizedToContent() && !host.isHeightSizedToContent()) {
    host.setWidth(viewportSize.width + vm.borderMetrics.left + vm.borderMetrics.right +
                               vm.chromeMetrics.left + vm.chromeMetrics.right + 1, false);
  }
};


Object.defineProperties(org.apache.flex.html.beads.ContainerView.prototype, {
    /** @export */
    contentView: {
        /** @this {org.apache.flex.html.beads.ContainerView} */
        get: function() {
            return this.viewport.contentView;
        }
    },
    /** @export */
    resizableView: {
        /** @this {org.apache.flex.html.beads.ContainerView} */
        get: function() {
            return this._strand;
        },
        /** @this {org.apache.flex.html.beads.ContainerView} */
        set: function(value) {
        }
    },
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.ContainerView} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(org.apache.flex.html.beads.ContainerView, this, 'strand', value);
            this.createViewport();
            this.host.addElement(this.viewport.contentView);
            this.host.setActualParent(this.viewport.contentView);
            this._strand.addEventListener('initComplete',
                  org.apache.flex.utils.Language.closure(this.initCompleteHandler, this, 'initCompleteHandler'));
         }
    },
    /** @export */
    viewport: {
        /** @this {org.apache.flex.html.beads.ContainerView} */
        set: function(value) {
            this.viewport_ = value;
        },
        /** @this {org.apache.flex.html.beads.ContainerView} */
        get: function() {
            return this.viewport_;
        }
    },
    /** @export */
    viewportModel: {
        /** @this {org.apache.flex.html.beads.ContainerView} */
        set: function(value) {
            this.viewportModel_ = value;
        },
        /** @this {org.apache.flex.html.beads.ContainerView} */
        get: function() {
            return this.viewportModel_;
        }
    },
    /** @export */
    layout: {
        /** @this {org.apache.flex.html.beads.ContainerView} */
        set: function(value) {
            this.layout_ = value;
        },
        /** @this {org.apache.flex.html.beads.ContainerView} */
        get: function() {
            return this.layout_;
        }
    }

});
