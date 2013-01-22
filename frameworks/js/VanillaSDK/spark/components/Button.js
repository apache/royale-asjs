goog.provide('spark.components.Button');

goog.require("goog.events.Event");

/**
 * @constructor
 */
spark.components.Button = function() {
	this.element = document.createElement('input');
	this.element.type = "button";
	this.element.value = "Click me";
	
	document.body.appendChild(this.element);
}

spark.components.Button.prototype.addEventListener = function(type, handler) {
	goog.events.listen(this.element, goog.events.EventType.CLICK, handler, false, this);
};