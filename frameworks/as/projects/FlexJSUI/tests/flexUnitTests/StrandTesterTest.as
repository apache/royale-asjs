package flexUnitTests
{
    import flexunit.framework.Assert;
    
    import org.apache.flex.core.Strand;
    
    public class StrandTesterTest
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
        public function testIdProperty():void
        {
            var strand:Strand = new Strand();
            strand.id = "foo";
            Assert.assertEquals("Error testing Srand.id", strand.id, "foo");
        }        
    }
}