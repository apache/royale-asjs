package org.apache.royale.style.stylebeads.effects
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;
	/**
	 * Multiple box shadows can be applied to an element, separated by commas.
	 * BoxShadows should contain an array of BoxShadow or RingEffect objects.
	 */
	public class BoxShadows extends LeafStyleBase
	{
		public function BoxShadows(value:* = null)
		{
			super("boxes", "box-shadow", value);
		}
		private var _shadows:Array;

		public function get shadows():Array
		{
			return _shadows;
		}

		public function set shadows(value:Array):void
		{
			_shadows = value;
		}
		override public function getRule():String
		{
			assert(shadows && shadows.length > 0, "BoxShadows style bead requires shadows to be set");
			var rules:Array = [];
			for each(var shadow:LeafStyleBase in shadows)
			{
				rules.push(shadow.getRule());
			}
			calculatedRuleValue = rules.join(", ");
			return super.getRule();
		}
		override public function getSelector():String
		{
			assert(shadows && shadows.length > 0, "BoxShadows style bead requires shadows to be set");
			var selectors:Array = [];
			for each(var shadow:LeafStyleBase in shadows)
			{
				assert(shadow is BoxShadow || shadow is RingEffect, "BoxShadows style bead only accepts BoxShadow or RingEffect style beads");
				selectors.push(shadow.getSelector());
			}
			calculatedSelector = selectors.join("-");
			return super.getSelector();
		}
	}
}