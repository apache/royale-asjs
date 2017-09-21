package {
import flash.display.DisplayObject;
import flash.system.Capabilities;
[Mixin]
/**
* By including this mixin via CompileMustellaSwfs, we
* can set up some variables for UnitTester to use for
* an Android run.
*/
public class MobileConfig
{
	public static function init(root:DisplayObject):void
	{
		if( UnitTester.cv == null ){
			UnitTester.cv = new ConditionalValue();
		}
		UnitTester.cv.device = "mac";
		UnitTester.cv.os = "android";
		UnitTester.cv.targetOS = "android";
		UnitTester.cv.osVersion = "${os_version}";
		UnitTester.cv.deviceDensity = Util.roundDeviceDensity( flash.system.Capabilities.screenDPI );
		UnitTester.cv.screenDPI = flash.system.Capabilities.screenDPI;
		//UnitTester.cv.deviceWidth = set by MultiResult;
		//UnitTester.cv.deviceHeight = set by MultiResult;
		//UnitTester.cv.color = this is not defined yet, but there are rumours it might be.
		UnitTester.run_id = "-1";
		UnitTester.excludeFile = "ExcludeList${os}.txt";
	}
}
}
