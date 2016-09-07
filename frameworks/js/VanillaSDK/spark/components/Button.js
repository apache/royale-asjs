////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
goog.provide('spark.components.Button');

goog.require("goog.dom");
goog.require("goog.events");

goog.require("other.ViewElement");

/**
 * @constructor
 * @extends {other.ViewElement}
 */
spark.components.Button = function() {
	var self = this;
	goog.base(this);
	
	self.element = goog.dom.createDom('button');
}
goog.inherits(spark.components.Button, other.ViewElement);

/**
 * @this {goog.events.EventTarget}
 * @param {string} type
 * @param {Object} listener
 * @param {boolean=} captureOnly
 * @param {Object=} handler
 */
spark.components.Button.prototype.addEventListener = function(type, listener, captureOnly, handler) {
	var self = this;
	goog.events.listen(self.element, type, listener, false, self.owner);
};

/**
 * @type {string}
 */
spark.components.Button.prototype.label;
Object.defineProperty(
	spark.components.Button.prototype, 
	'label', 
	{
		get:function() {
			var self = this;
			return self.element.innerHTML;
		}, 
		set:function(value) {
			var self = this;
			self.element.innerHTML = value;
		}
	}
);
