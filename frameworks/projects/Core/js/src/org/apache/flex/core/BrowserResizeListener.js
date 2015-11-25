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

goog.provide('org.apache.flex.core.BrowserResizeListener');



/**
 * @constructor
 */
org.apache.flex.core.BrowserResizeListener = function() {
  this.strand_ = null;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.BrowserResizeListener.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BrowserResizeListener',
                qName: 'org.apache.flex.core.BrowserResizeListener'}]};


/**
 * @type {number}
 */
org.apache.flex.core.BrowserResizeListener.prototype.minHeight = NaN;


/**
 * @type {number}
 */
org.apache.flex.core.BrowserResizeListener.prototype.minWidth = NaN;


/**
 * @param {Event} e The event.
 */
org.apache.flex.core.BrowserResizeListener.prototype.resizeHandler = function(e) {
  var initialView = this.strand_.initialView;
  var element = this.strand_.element;
  if (!isNaN(initialView.percentWidth) || !isNaN(initialView.percentHeight)) {
    element.style.height = window.innerHeight.toString() + 'px';
    element.style.width = window.innerWidth.toString() + 'px';
    initialView.dispatchEvent('sizeChanged'); // kick off layout if % sizes
  }
};


Object.defineProperties(org.apache.flex.core.BrowserResizeListener.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.core.BrowserResizeListener} */
        set: function(value) {
            this.strand_ = value;
            window.addEventListener('resize',
                    goog.bind(this.resizeHandler, this));
            if (!isNaN(this.minWidth))
              document.body.style.minWidth = this.minWidth.toString() + 'px';
            if (!isNaN(this.minHeight))
              document.body.style.minHeight = this.minHeight.toString() + 'px';
            document.body.style.overflow = 'auto';
        }
    }
});
