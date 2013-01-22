goog.provide('mx.core.UIComponent');

/**
 * @constructor
 */
mx.core.UIComponent = function() {
	this.element = goog.dom.createDom('div');
	goog.dom.appendChild(document.body, this.element);
}

/**
 * @type {mx.core.UIComponent}
 */
mx.core.UIComponent.prototype.addChild = function(child) {
	goog.dom.appendChild(this.element, child);
}

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
			return this.element.style.offsetLeft;
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
			return this.element.style.offsetTop;
		}, 
	set:
		function(value) {
			this.element.style.top = value + "px";
		}
	}
);
