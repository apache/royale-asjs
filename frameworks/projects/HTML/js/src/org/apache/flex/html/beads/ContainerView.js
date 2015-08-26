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
goog.require('org.apache.flex.html.beads.models.ViewportModel');
goog.require('org.apache.flex.html.supportClasses.ContainerContentArea');
goog.require('org.apache.flex.html.supportClasses.Viewport');



/**
 * @constructor
 * @extends {org.apache.flex.core.BeadViewBase}
 */
org.apache.flex.html.beads.ContainerView = function() {
  this.lastSelectedIndex = -1;
  org.apache.flex.html.beads.ContainerView.base(this, 'constructor');

  this.className = 'ContainerView';
  this.resizingChildren = false;
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
 * @return {Object} The container's child content area.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.createContentView = function() {
  return new org.apache.flex.html.supportClasses.ContainerContentArea();
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.initCompleteHandler = function(event) {
  if ((this.host.isHeightSizedToContent() || !isNaN(this.host.explicitHeight)) &&
      (this.host.isWidthSizedToContent() || !isNaN(this.host.explicitWidth))) {
         this.completeSetup();

         var num = this.contentView.numElements;
         if (num > 0) {
           this.performLayout(event);
         }
   }
   else {
     this._strand.addEventListener('sizeChanged',
       goog.bind(this.deferredSizeHandler, this));
   }
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.deferredSizeHandler = function(event) {
    this._strand.removeEventListener('sizeChanged',
      goog.bind(this.deferredSizeHandler, this));
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
          goog.bind(this.childResizeHandler, this));
      child.addEventListener('heightChanged',
          goog.bind(this.childResizeHandler, this));
    }
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.sizeChangeHandler = function(event) {
  this.performLayout(event);
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.resizeHandler = function(event) {
  this.performLayout(event);
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
 org.apache.flex.html.beads.ContainerView.
    prototype.childResizeHandler = function(event) {
    if (this.resizingChildren) return;
    this.resizingChildren = true;
    this.performLayout(event);
    this.resizingChildren = false;
};


/**
 *
 */
org.apache.flex.html.beads.ContainerView.
    prototype.completeSetup = function() {
  this.createViewport();

   this._strand.addEventListener('childrenAdded',
      goog.bind(this.childrenChangedHandler, this));
   this.childrenChangedHandler(null);
   this._strand.addEventListener('childrenAdded',
      goog.bind(this.changeHandler, this));
  this._strand.addEventListener('childrenRemoved',
      goog.bind(this.changeHandler, this));
  this._strand.addEventListener('layoutNeeded',
     goog.bind(this.performLayout, this));
  this._strand.addEventListener('widthChanged',
     goog.bind(this.resizeHandler, this));
  this._strand.addEventListener('heightChanged',
     goog.bind(this.resizeHandler, this));
  this._strand.addEventListener('sizeChanged',
     goog.bind(this.resizeHandler, this));
};


/**
 * Creates the viewport and viewportModel.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.createViewport = function() {
  if (this.viewportModel_ == null) {
    this.viewportModel_ = new org.apache.flex.html.beads.models.ViewportModel();
    this.viewportModel_.contentArea = this.contentView;
    this.viewportModel_.contentIsHost = false;
  }
  if (this.viewport_ == null) {
    this.viewport_ = new org.apache.flex.html.supportClasses.Viewport();
    this.viewport_.model = this.viewportModel_;
    this._strand.addBead(this.viewport_);
  }
};


/**
 *
 */
org.apache.flex.html.beads.ContainerView.
    prototype.adjustSizeBeforeLayout = function() {
    this.viewportModel_.contentWidth = this._strand.width;
    this.viewportModel_.contentHeight = this._strand.height;
    this.viewportModel_.contentX = 0;
    this.viewportModel_.contentY = 0;
};


/**
 * @param {org.apache.flex.events.Event} event The event.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.performLayout = function(event) {
  this.adjustSizeBeforeLayout();
  if (this.layout == null) {
    this.layout = this._strand.getBeadByType(org.apache.flex.core.IBeadLayout);
    if (this.layout == null) {
      var m3 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this._strand, 'iBeadLayout');
      this.layout = new m3();
      this._strand.addBead(this.layout);
    }
  }
  this.resizingChildren = true;
  /*
  org.apache.flex.utils.Language.trace(this._strand.id);
  var foo = false;
  if (foo)
  */
    this.layout.layout();
  this.resizingChildren = false;

  this.adjustSizeAfterLayout();
};


/**
 *
 */
org.apache.flex.html.beads.ContainerView.
    prototype.adjustSizeAfterLayout = function() {
  var max = this.contentView.width;//this.layout.maxWidth;
  if (isNaN(this.resizableView.explicitWidth) && !isNaN(max))
    this.resizableView.setWidth(max, true);
  max = this.contentView.height;//this.layout.maxHeight;
  if (isNaN(this.resizableView.explicitHeight) && !isNaN(max))
    this.resizableView.setHeight(max, true);

  this.layoutContainer(false, false);

  // The JS version of Panel matches the content space to the viewport since HTML
  // takes care of scrollbars
  this.viewportModel_.contentX = this.viewportModel_.viewportX;
  this.viewportModel_.contentY = this.viewportModel_.viewportY;
  this.viewportModel_.contentWidth = this.viewportModel_.viewportWidth;
  this.viewportModel_.contentHeight = this.viewportModel_.viewportHeight;

  this.contentView.x = this.viewportModel_.contentX;
  this.contentView.y = this.viewportModel_.contentY;
  this.contentView.width = this.viewportModel_.contentWidth;
  this.contentView.height = this.viewportModel_.contentHeight;

  this.viewport_.updateSize();
  this.viewport_.updateContentAreaSize();
};


/**
 * @expose
 * This function determines the size and placement of the viewport by adjusting the viewport
 * values in the viewportModel. Subclasses can use this to position additional items. If either
 * of the two parameters are true, the subclass should adjust the size of the host accordingly
 * to account for any additional elements.
 *
 * @param {boolean} widthSizedToContent True if the width of the container is being sized by its content.
 * @param {boolean} heightSizedToContent True if the height of the container is being sized by its content.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.layoutContainer = function(widthSizedToContent, heightSizedToContent) {
  this.viewportModel_.viewportHeight = this._strand.height;
  this.viewportModel_.viewportWidth = this._strand.width;
  this.viewportModel_.viewportX = 0;
  this.viewportModel_.viewportY = 0;
};


/**
 *
 */
org.apache.flex.html.beads.ContainerView.
    prototype.determineContentSizeFromChildren = function() {
  // this function has no meaning in the HTML world
};


/**
 * Adjusts the size of the viewportModel's viewport parameters to match those
 * of the strand.
 */
org.apache.flex.html.beads.ContainerView.
    prototype.resizeViewport = function() {
/*  this.viewportModel_.viewportHeight = this._strand.height;
  this.viewportModel_.viewportWidth = this._strand.width;
  this.viewportModel_.viewportX = 0;
  this.viewportModel_.viewportY = 0;*/
};


Object.defineProperties(org.apache.flex.html.beads.ContainerView.prototype, {
    /** @export */
    contentView: {
        /** @this {org.apache.flex.html.beads.ContainerView} */
        get: function() {
            return this.contentArea_;
        },
        /** @this {org.apache.flex.html.beads.ContainerView} */
        set: function(value) {
            this.contentArea_ = value;
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
            this.contentView = this.createContentView();
            this.contentView.percentWidth = 100;
            this.contentView.percentHeight = 100;
            this.host.addElement(this.contentView);
            this.host.setActualParent(this.contentView);
            this._strand.addEventListener('initComplete',
                  goog.bind(this.initCompleteHandler, this));
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
