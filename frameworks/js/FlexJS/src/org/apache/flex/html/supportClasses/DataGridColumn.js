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

goog.provide('org_apache_flex_html_supportClasses_DataGridColumn');

goog.require('mx_core_IFactory');



/**
 * @constructor
 */
org_apache_flex_html_supportClasses_DataGridColumn =
    function() {
};


Object.defineProperties(org_apache_flex_html_supportClasses_DataGridColumn.prototype, {
    /** @expose */
    itemRenderer: {
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        get: function() {
            return this.itemRenderer_;
        },
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        set: function(value) {
            this.itemRenderer_ = value;
        }
    },
    /** @expose */
    columnWidth: {
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        get: function() {
            return this.columnWidth_;
        },
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        set: function(value) {
            this.columnWidth_ = value;
        }
    },
    /** @expose */
    label: {
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        get: function() {
            return this.label_;
        },
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        set: function(value) {
            this.label_ = value;
        }
    },
    /** @expose */
    dataField: {
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        get: function() {
            return this.dataField_;
        },
        /** @this {org_apache_flex_html_supportClasses_DataGridColumn} */
        set: function(value) {
            this.dataField_ = value;
        }
    }
});

