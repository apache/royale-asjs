package flexUnitTests
{
    import flexunit.framework.Assert;
    
    import org.apache.flex.html.staticControls.supportClasses.DataGridColumn;
    
    public class DataGridColumnTesterTest
    {		
        [Before]
        public function setUp():void
        {
        }
        
        [After]
        public function tearDown():void
        {
        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        [Test]
        public function testLabelProperty():void
        {
            var column:DataGridColumn = new DataGridColumn();
            column.label = "foo";
            Assert.assertEquals("Error testing DataGridColumn.label", column.label, "foo");
        }        
    }
}