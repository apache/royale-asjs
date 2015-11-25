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

goog.provide('org.apache.flex.html.supportClasses.DataGridColumn');

goog.require('org.apache.flex.core.IFactory');



/**
 * @constructor
 */
org.apache.flex.html.supportClasses.DataGridColumn =
    function() {
};


Object.defineProperties(org.apache.flex.html.supportClasses.DataGridColumn.prototype, {
    /** @export */
    itemRenderer: {
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        get: function() {
            return this.itemRenderer_;
        },
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        set: function(value) {
            this.itemRenderer_ = value;
        }
    },
    /** @export */
    columnWidth: {
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        get: function() {
            return this.columnWidth_;
        },
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        set: function(value) {
            this.columnWidth_ = value;
        }
    },
    /** @export */
    label: {
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        get: function() {
            return this.label_;
        },
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        set: function(value) {
            this.label_ = value;
        }
    },
    /** @export */
    dataField: {
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        get: function() {
            return this.dataField_;
        },
        /** @this {org.apache.flex.html.supportClasses.DataGridColumn} */
        set: function(value) {
            this.dataField_ = value;
        }
    }
});

