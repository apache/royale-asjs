goog.provide('mx.core.UIComponent');

/**
 * @constructor
 */
mx.core.UIComponent = function() {
}

/**
 * @type {Object}
 */
mx.core.UIComponent.prototype.element;

/**
 * @type {number}
 */
mx.core.UIComponent.prototype.x;
Object.defineProperty(
	mx.core.UIComponent.prototype, 
	'x', 
	{
	get:
		function() {
			return this.element.offsetLeft;
		}, 
	set:
		function(value) {
			this.element.style.left = value + "px";
		}
	}
);

/**
 * @type {number}
 */
mx.core.UIComponent.prototype.y;
Object.defineProperty(
	mx.core.UIComponent.prototype, 
	'y', 
	{
	get:
		function() {
			return this.element.offsetTop;
		}, 
	set:
		function(value) {
			this.element.style.top = value + "px";
		}
	}
);
