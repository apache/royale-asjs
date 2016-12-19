package org.apache.flex.utils
{
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ILayoutParent;
	
	public class AbsoluteLayoutTweener extends LayoutTweener
	{
		public function AbsoluteLayoutTweener(sourceLayout:IBeadLayout, sourceLayoutParent:ILayoutParent)
		{
			super(sourceLayout, sourceLayoutParent);
			effectGenerators = Vector.<IEffectsGenerator>([new MoveGenerator(), new ResizeGenerator()]);
		}
	}
}