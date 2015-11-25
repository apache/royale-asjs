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

goog.provide('org.apache.flex.html.supportClasses.ScrollingViewport');

goog.require('org.apache.flex.events.Event');
goog.require('org.apache.flex.geom.Size');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBead}
 * @implements {org.apache.flex.core.IViewport}
 */
org.apache.flex.html.supportClasses.ScrollingViewport =
function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.ScrollingViewport.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ScrollingViewport',
                qName: 'org.apache.flex.html.supportClasses.ScrollingViewport' }],
      interfaces: [org.apache.flex.core.IBead,
                   org.apache.flex.core.IViewport]};


/**
 * @protected
 * @type {Object}
 */
org.apache.flex.html.supportClasses.ScrollingViewport.prototype._strand = null;


/**
 * @type {org.apache.flex.html.supportClasses.ContainerContentArea}
 */
org.apache.flex.html.supportClasses.ScrollingViewport.prototype.contentView = null;


/**
 * @param {number} x The x position of the viewport.
 * @param {number} y The y position of the viewport.
 */
org.apache.flex.html.supportClasses.ScrollingViewport.prototype.setPosition =
   function(x, y) {
  this.contentView.x = x;
  this.contentView.y = y;
};


/**
 * @param {number} width The width or NaN if sized to content.
 * @param {number} height The height or NaN if sized to content.
 */
org.apache.flex.html.supportClasses.ScrollingViewport.prototype.layoutViewportBeforeContentLayout =
   function(width, height) {
  if (!isNaN(width))
    this.contentView.width = width;
  if (!isNaN(height))
    this.contentView.height = height;
};


/**
 * @return {org.apache.flex.geom.Size} The size of the viewport.
 */
org.apache.flex.html.supportClasses.ScrollingViewport.prototype.layoutViewportAfterContentLayout =
   function() {
  // nothing to do here?  In theory, the layout and browser will have stretched or shrunk
  // the contentView to the right size
  return new org.apache.flex.geom.Size(this.contentView.width, this.contentView.height);
};


Object.defineProperties(org.apache.flex.html.supportClasses.ScrollingViewport.prototype, {
    /** @export */
    verticalScrollPosition: {
        /** @this {org.apache.flex.html.supportClasses.ScrollingViewport} */
        get: function() {
            return this.contentView.positioner.scrollTop;
        },
        /** @this {org.apache.flex.html.supportClasses.ScrollingViewport} */
        set: function(value) {
            this.contentView.positioner.scrollTop = value;
        }
    },
    /** @export */
    horizontalScrollPosition: {
        /** @this {org.apache.flex.html.supportClasses.ScrollingViewport} */
        get: function() {
             return this.contentView.positioner.scrollLeft;
        },
        /** @this {org.apache.flex.html.supportClasses.ScrollingViewport} */
        set: function(value) {
             this.contentView.positioner.scrollLeft = value;
        }
    },
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.supportClasses.ScrollingViewport} */
        set: function(value) {
            this._strand = value;
            this.contentView = this._strand.getBeadByType(org.apache.flex.core.IContentView);
            if (this.contentView == null) {
              var c = org.apache.flex.core.ValuesManager.valuesImpl.getValue(
                       this._strand, 'iContentView');
              if (c)
                this.contentView = new c();
            }
            this.contentView.element.style.overflow = 'auto';
         }
    }
});
