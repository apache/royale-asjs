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
 * org.apache.flex.core.IContentView
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.IContentView');



/**
 * @interface
 */
org.apache.flex.core.IContentView = function() {
};


Object.defineProperties(org.apache.flex.core.IContentView.prototype, {
    /** @export */
    x: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    y: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    width: {
        get: function() {},
        set: function(value) {}
    },
    /** @export */
    height: {
        get: function() {},
        set: function(value) {}
    }
});


/**
 * Adds a new element to component.
 * @param {Object} value The child element being added.
 */
org.apache.flex.core.IContentView.prototype.addElement = function(value) {};


/**
 * Removes all of the component's children.
 * @return {void}
 */
org.apache.flex.core.IContentView.prototype.removeAllElements = function() {};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IContentView.prototype.FLEXJS_CLASS_INFO = {
  names: [{ name: 'IContentView', qName: 'org.apache.flex.core.IContentView'}]
};
