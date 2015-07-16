/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.IDocument');



/**
 * IDocument
 *
 * @interface
 */
org.apache.flex.core.IDocument = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IDocument.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'IDocument',
                qName: 'org.apache.flex.core.IDocument' }] };


/**
 * setDocument()
 *
 * @export
 * @param {Object} document The DOM document element.
 * @param {string=} opt_id The id (optional).
 */
org.apache.flex.core.IDocument.prototype.setDocument =
    function(document, opt_id) {};
