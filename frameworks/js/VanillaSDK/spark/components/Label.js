goog.provide('spark.components.Label');

/**
 * @constructor
 */
spark.components.Label = function() {
	this.element = goog.dom.createDom('div', null, 'Boo!');
	goog.dom.appendChild(document.body, this.element);
}

/**
 * @type {number}
 */
spark.components.Label.prototype.a;

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