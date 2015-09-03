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

goog.provide('org.apache.flex.core.BrowserScroller');



/**
 * @constructor
 */
org.apache.flex.core.BrowserScroller = function() {
  this.strand_ = null;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.BrowserScroller.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BrowserScroller',
                qName: 'org.apache.flex.core.BrowserScroller'}]};


/**
 * @param {Event} e The event.
 */
org.apache.flex.core.BrowserScroller.prototype.viewChangedHandler = function(e) {
  this.strand_.element.style.overflow = 'auto';
};


Object.defineProperties(org.apache.flex.core.BrowserScroller.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.core.BrowserScroller} */
        set: function(value) {
            this.strand_ = value;
            value.addEventListener('viewChanged',
                    goog.bind(this.viewChangedHandler, this));
        }
    }
});
