package tests
{
	import org.apache.royale.test.Assert;

	public class ScopeTests
	{
		private var _value:String = "hello";

		[Before]
		public function prepare():void
		{
			Assert.strictEqual(this._value, "hello",
				"Function marked with [Before] metadata called with incorrect scope.");
		}

		[After]
		public function cleanup():void
		{
			Assert.strictEqual(this._value, "hello",
				"Function marked with [After] metadata called with incorrect scope.");
		}

		[Test]
		public function testScope():void
		{
			Assert.strictEqual(this._value, "hello",
				"Function marked with [Test] metadata called with incorrect scope.");
		}
	}
}