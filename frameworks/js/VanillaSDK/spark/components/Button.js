goog.provide('spark.components.Button');

goog.require("goog.dom");
goog.require("goog.events");
goog.require("goog.events.EventType");

/**
 * @constructor
 */
spark.components.Button = function() {
	this.element = goog.dom.createDom('button', {'id':'button'}, 'Click here');
	goog.dom.appendChild(document.body, this.element);
}

spark.components.Button.prototype.addEventListener = function(type, handler) {
	goog.events.listen(this.element, goog.events.EventType.CLICK, handler, false, this);
};