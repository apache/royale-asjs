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
 * org.apache.flex.core.IViewportModel
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.IViewportModel');

goog.require('org.apache.flex.core.IBeadModel');



/**
 * @interface
 * @extends {org.apache.flex.core.IBeadModel}
 */
org.apache.flex.core.IViewportModel = function() {
};


Object.defineProperties(org.apache.flex.core.IViewportModel.prototype, {
    /** @export */
    contentIsHost: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    contentArea: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    viewportX: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    viewportY: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    viewportWidth: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    viewportHeight: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    contentX: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    contentY: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    contentWidth: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    contentHeight: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    verticalScrollPosition: {
        set: function(value) {},
        get: function() {}
    },
    /** @export */
    horizontalScrollPosition: {
        set: function(value) {},
        get: function() {}
    }
});


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IViewportModel.prototype.FLEXJS_CLASS_INFO =
{ names: [{ name: 'IViewportModel', qName: 'org.apache.flex.core.IViewportModel'}],
  interfaces: [org.apache.flex.core.IBeadModel] };
