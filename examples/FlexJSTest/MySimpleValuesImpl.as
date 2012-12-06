package 
{
	import flash.events.IEventDispatcher;
	
	import org.apache.flex.core.SimpleValuesImpl;
	import org.apache.flex.html.staticControls.beads.TextButtonBead;
	import org.apache.flex.html.staticControls.beads.TextFieldBead;
	import org.apache.flex.html.staticControls.beads.models.TextModel;
	
	public class MySimpleValuesImpl extends SimpleValuesImpl
	{
		public function MySimpleValuesImpl()
		{
			super();
			values = { 
				ITextButtonBead: TextButtonBead,
				ITextBead: TextFieldBead,
				ITextModel: TextModel				
			}
		}
		
		
	}
}