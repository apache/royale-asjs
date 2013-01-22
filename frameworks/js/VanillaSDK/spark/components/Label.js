goog.provide('spark.components.Label');

/**
 * @constructor
 */
spark.components.Label = function() {
	this.element = document.createElement('div');
	this.element.innerHTML = "Hello World";
	
	document.body.appendChild(this.element);
}
