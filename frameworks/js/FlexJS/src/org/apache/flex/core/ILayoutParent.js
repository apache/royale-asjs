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

goog.provide('org_apache_flex_core_ILayoutParent');



/**
 * @interface
 */
org_apache_flex_core_ILayoutParent = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_ILayoutParent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ILayoutParent',
                qName: 'org_apache_flex_core_ILayoutParent' }] };


/**
 * @expose
 * @return {Object} The view that contains the layout objects.
 */
org_apache_flex_core_ILayoutParent.prototype.get_contentView = function() {};


/**
 * @expose
 * @return {Object} The border for the layout area.
 */
org_apache_flex_core_ILayoutParent.prototype.get_border = function() {};


/**
 * @expose
 * @return {Object} The vertical scrollbar.
 */
org_apache_flex_core_ILayoutParent.prototype.get_vScrollBar = function() {};


/**
 * @expose
 * @param {Object} value The vertical scrollbar.
 */
org_apache_flex_core_ILayoutParent.prototype.set_vScrollBar = function(value) {};


/**
 * @expose
 * @return {Object} The view that can be resized.
 */
org_apache_flex_core_ILayoutParent.prototype.get_resizeableView = function() {};
