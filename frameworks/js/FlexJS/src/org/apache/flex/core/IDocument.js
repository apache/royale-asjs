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

/*jshint globalstrict: true, indent: 2, maxlen: 80, strict: true,
    white: false */
/*global goog, org */

'use strict';

goog.provide('org.apache.flex.core.IDocument');



/**
 * IDocument
 *
 * @interface
 */
org.apache.flex.core.IDocument = function() {
};


/**
 * setDocument()
 *
 * @expose
 * @param {Object} document The DOM document element.
 * @param {string=} opt_id The id (optional).
 */
org.apache.flex.core.IDocument.prototype.setDocument =
    function(document, opt_id) {};
