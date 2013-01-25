goog.provide('spark.components.Group');

goog.require("goog.dom");

/**
 * @constructor
 */
spark.components.Group = function() {
}

/**
 * @param {Object} object
 */
spark.components.Group.prototype.addElement = function(object) {
	object.element.style.position = "absolute";
	
	goog.dom.appendChild(document.body, object.element);
	
	object.owner = this;
};
