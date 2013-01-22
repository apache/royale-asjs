goog.provide('spark.components.Button');

goog.require("goog.dom");
goog.require("goog.events");
goog.require("goog.events.EventType");

goog.require("mx.core.UIComponent");

/**
 * @constructor
 */
spark.components.Button = function() {
	goog.base(this);
	
	this.element = goog.dom.createDom('button', {'id':'button'}, 'Click here');
	this.addChild(this.element);
}
goog.inherits(spark.components.Button, mx.core.UIComponent);

spark.components.Button.prototype.addEventListener = function(type, handler) {
	goog.events.listen(this.element, goog.events.EventType.CLICK, handler, false, this);
};