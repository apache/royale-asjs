goog.provide('spark.components.Image');

/**
 * @constructor
 */
spark.components.Image = function() {
	this.element = document.createElement('img');
	this.element.src = "";
	
	document.body.appendChild(this.element);
}
