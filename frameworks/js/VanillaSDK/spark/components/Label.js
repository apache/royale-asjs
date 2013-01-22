goog.provide('spark.components.Label');

goog.require("mx.core.UIComponent");

/**
 * @constructor
 */
spark.components.Label = function() {
	goog.base(this);
	
	this.element = goog.dom.createDom('div', null, 'Boo!');
	this.addChild(this.element);
}
goog.inherits(spark.components.Label, mx.core.UIComponent);

/**
 * @type {string}
 */
spark.components.Label.prototype.text;

Object.defineProperty(
	spark.components.Label.prototype, 
	'text', 
	{get:function() {
		return this.element.innerHTML;
	}, configurable:true}
);

Object.defineProperty(
	spark.components.Label.prototype, 
	'text', 
	{set:function(value) {
		this.element.innerHTML = value;
	}, configurable:true}
);