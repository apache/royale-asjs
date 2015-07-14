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

goog.provide('org_apache_flex_core_CSSFontFaceBead');



/**
 * @constructor
 * This is just a stub.
 */
org_apache_flex_core_CSSFontFaceBead = function() {

  /**
   * @private
   * @type {Object}
   */
  this.strand_ = null;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_CSSFontFaceBead.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'CSSFontFaceBead.js',
                qName: 'org_apache_flex_core_CSSFontFaceBead'}] };


Object.defineProperties(org_apache_flex_core_CSSFontFaceBead.prototype, {
    /** @export */
    strand: {
        /** @this {org_apache_flex_binding_GenericBinding} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
            }
        }
    }
});
