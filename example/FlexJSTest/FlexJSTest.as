package
{
	import org.apache.flex.core.Application;
	import models.MyModel;
	import controllers.MyController;
	
	public class FlexJSTest extends Application
	{
		public function FlexJSTest()
		{
			valuesImplClass = MySimpleValuesImpl;
			initialViewClass = MyInitialView;
			model = new MyModel();
			model.labelText = "Hello World!";
			controller = new MyController(this);
		}
		
		private var controller:MyController;
		public var model:MyModel;
	}
}