package tests
{
	import org.apache.royale.test.TestRunner;
	import org.apache.royale.test.Assert;

	public class DetectMetadataTests
	{
		[Test]
		public function testBeforeTestAfterMetadata():void
		{
			var runner:TestRunner = new TestRunner();
			runner.run(new <Class>[TestClass]);
			Assert.true(TestClass.before);
			Assert.true(TestClass.test);
			Assert.true(TestClass.after);
		}
	}
}

class TestClass
{
	public static var before:Boolean = false;
	public static var after:Boolean = false;
	public static var test:Boolean = false;

	[Before]
	public function testBeforeMetadata():void
	{
		TestClass.before = true;
	}

	[After]
	public function testAfterMetadata():void
	{
		TestClass.after = true;
	}

	[Test]
	public function testTestMetadata():void
	{
		TestClass.test = true;
	}
}