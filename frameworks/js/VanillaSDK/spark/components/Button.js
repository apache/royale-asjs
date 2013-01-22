goog.provide('spark.components.Button');

goog.require("goog.dom");
goog.require("goog.events");
goog.require("goog.events.EventType");

goog.require("mx.core.UIComponent");

/**
 * @constructor
 * @extends {mx.core.UIComponent}
 */
spark.components.Button = function() {
	goog.base(this);
	
	this.element = goog.dom.createDom('button', {'id':'button'});
}
goog.inherits(spark.components.Button, mx.core.UIComponent);

spark.components.Button.prototype.addEventListener = function(type, handler) {
	goog.events.listen(this.element, goog.events.EventType.CLICK, handler, false, this);
};

/**
 * @type {string}
 */
spark.components.Button.prototype.label;

Object.defineProperty(
	spark.components.Button.prototype, 
	'label', 
	{get:function() {
		return this.element.innerHTML;
	}, configurable:true}
);

Object.defineProperty(
	spark.components.Button.prototype, 
	'label', 
	{set:function(value) {
		this.element.innerHTML = value;
	}, configurable:true}
);
