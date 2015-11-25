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
