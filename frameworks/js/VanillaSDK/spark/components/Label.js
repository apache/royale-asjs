goog.provide('spark.components.Label');

goog.require("other.ViewElement");

/**
 * @constructor
 * @extends {other.ViewElement}
 */
spark.components.Label = function() {
	var self = this;
	goog.base(this);
	
	self.element = goog.dom.createDom('div', null, 'Boo!');
}
goog.inherits(spark.components.Label, other.ViewElement);

/**
 * @type {string}
 */
spark.components.Label.prototype.text;
Object.defineProperty(
	spark.components.Label.prototype, 
	'text', 
	{
		get:function() {
			var self = this;
			return self.element.innerHTML;
		},
		set:function(value) {
			var self = this;
			self.element.innerHTML = value;
		}
	}
);
