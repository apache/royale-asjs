package org.apache.royale.style.stylebeads.states
{
	public class CheckedState extends LeafDecorator
	{
		public function CheckedState(styles:Array = null)
		{
			super();
			preDecorator = "checked:";
			postDecorator = ":checked";
			this.styles = styles;
		}
	}
}