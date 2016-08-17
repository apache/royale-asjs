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
goog.provide('other.ViewElement');

goog.require('goog.events.EventTarget');

/**
 * @constructor
 * @extends {goog.events.EventTarget}
 */
other.ViewElement = function() {
	var self = this;
	goog.base(this);
}
goog.inherits(other.ViewElement, goog.events.EventTarget);

/**
 * @type {Object}
 */
other.ViewElement.prototype.element;

/**
 * @type {Object}
 */
other.ViewElement.prototype.owner;

/**
 * @type {number}
 */
other.ViewElement.prototype.x;
Object.defineProperty(
	other.ViewElement.prototype, 
	'x', 
	{
		get:function() {
			var self = this;
			return self.element.offsetLeft;
		}, 
		set:function(value) {
			var self = this;
			self.element.style.left = value + "px";
		}
	}
);

/**
 * @type {number}
 */
other.ViewElement.prototype.y;
Object.defineProperty(
	other.ViewElement.prototype, 
	'y', 
	{
		get:function() {
			var self = this;
			return self.element.offsetTop;
		}, 
		set:function(value) {
			var self = this;
			self.element.style.top = value + "px";
		}
	}
);
