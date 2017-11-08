package
{
	import org.apache.royale.test.TestRunner;
	import org.apache.royale.test.events.TestEvent;
	import org.apache.royale.test.listeners.TraceListener;
	import tests.ScopeTests;
	import tests.DetectMetadataTests;

	public class NodeTests
	{
		public function NodeTests()
		{
			this._runner = new TestRunner();
			new TraceListener(this._runner);
			this._runner.addEventListener(TestEvent.TEST_RUN_COMPLETE, runner_testRunCompleteHandler);
			this._runner.addEventListener(TestEvent.TEST_RUN_FAIL, runner_testRunFailHandler);
			this._runner.run(new <Class>
			[
				DetectMetadataTests,
				ScopeTests,
				AssertTests
			]);
		}

		private var _runner:TestRunner;

		private function runner_testRunCompleteHandler(event:TestEvent):void
		{
			process.exit(0);
		}

		private function runner_testRunFailHandler(event:TestEvent):void
		{
			process.exit(1);
		}
	}
}