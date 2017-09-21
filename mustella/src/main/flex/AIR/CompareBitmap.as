////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package AIR { 

import flash.display.*;
import flash.events.*;
import flash.filesystem.*;
import flash.net.*;
import flash.text.*;
import flash.text.engine.*;
import flash.geom.ColorTransform;
import flash.utils.*;
import flash.filesystem.*;
import flash.geom.*;
import mx.core.IChildList;
import mx.core.IRawChildrenContainer;
import mx.core.mx_internal;
use namespace mx_internal;

/**
*  Vector of conditionalValue objects.
**/
[DefaultProperty("conditionalValues")]

/**
 *  The test step that compares a bitmap against a reference bitmap
 *  MXML attributes:
 *  target
 *  url
 *  timeout (optional);
 *  stageText (optional)
 *  maxColorVariance
 *  numColorVariances
 *  waitTarget Do Not Use
 *  waitEvent Do Not Use
 *
 *  Do not set waitEvent or waitTarget on this step.  They are set internally
 *  to manage the loading of the reference bitmap.  The step prior to this
 *  step must wait for the system to synch up.
 *  
 *  CompareBitmap will parse the url attribute for $testID, replacing with the current testID
 */
public class CompareBitmap extends Assert
{ 
	public static var useRemoteDiffer:Boolean = false;

	private static var identityMatrix:String = new Matrix().toString();
	private static var identityColorTransform:String = new ColorTransform().toString();
	
	public static var DEFAULT_MAX_COLOR_VARIANCE:int = 0;
	public static var DEFAULT_NUM_COLOR_VARIANCES:int = 0;

	// This is the default property.
	public var conditionalValues:Vector.<ConditionalValue> = null;
	
	/**
	 *  The url of the file to read. If UnitTester.createBitmapReferences = true,
	 *  the url to store the bitmap
	 */
	public var url:String;


	/**
	 *  If the user tells us it's a stageText, we'll try to grab the bitmapdata 
	 *  via mx_internal call 
	 */
	public var stageText:Boolean

	private var _maxColorVariance:int = 0;
	/**
	 *  The maximum color variation allowed in a bitmap compare.
	 *  Some machines render slightly differently and thus we have
	 *  to allow the the compare to not be exact.
	 */
	public function get maxColorVariance():int
	{
		if (_maxColorVariance)
			return _maxColorVariance;

		return DEFAULT_MAX_COLOR_VARIANCE;
	}
	public function set maxColorVariance(value:int):void
	{
		_maxColorVariance = value;
	}

	private var _ignoreMaxColorVariance:Boolean = false;
	
	/**
	 * Sometimes you have numColorVariance defined and you don't really care by how much the pixel really differ.
	 * as long as the number of mismatching pixels is &lt;= numColorVariance
	 * Setting this to true will skip the maxColorVariance check (and take the guess work out of picture). default is false
	 */
	public function get ignoreMaxColorVariance():Boolean
	{
		return _ignoreMaxColorVariance;
	}
	
	public function set ignoreMaxColorVariance(value:Boolean):void
	{
		_ignoreMaxColorVariance = value;
	}


	private var _numColorVariances:int = 0;
	/**
	 *  The number of color variation allowed in a bitmap compare.
	 *  Some machines render slightly differently and thus we have
	 *  to allow the the compare to not be exact.
	 */
	public function get numColorVariances():int
	{
		if (_numColorVariances)
			return _numColorVariances;

		return DEFAULT_NUM_COLOR_VARIANCES;
	}
	public function set numColorVariances(value:int):void
	{
		_numColorVariances = value;
	}

	/**
	 *  Suffix to add to the file being written out (the case of a compare failure)
	 */
	public static var fileSuffix:String = "";

	private var reader:Loader;
	private var xmlreader:URLLoader;
	private var writer:URLLoader;

	private static var connection:LocalConnection;
	private static var commandconnection:LocalConnection;
	
	private function statusHandler(event:Event):void
	{
	}

	/**
	 *  Constructor
	 */
	public function CompareBitmap() 
	{ 
		if (!connection)
		{
			connection = new LocalConnection();
			connection.allowDomain("*");
			connection.addEventListener(StatusEvent.STATUS, statusHandler);

			commandconnection = new LocalConnection();
			commandconnection.allowDomain("*");

			try
			{
				commandconnection.connect("_ImageDifferCommands");
			}
			catch (e:Error)
			{
				trace("connection failed");
			}
		}

	}

	// We override execute here.  In other TestSteps, we override doStep().
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		var cv:ConditionalValue = null;
		var configID:String = null;
		
		if( conditionalValues ){			
			// Use MultiResult to determine the proper URL.
			cv = new MultiResult().chooseCV(conditionalValues);
			if(cv){
				// Use thet cv's url if it is set; otherwise, stick with the CompareBitmap's url (directory).
				if( cv.url != null ){
					url = cv.url;
				}
			}
		}else{
			// We do not have ConditionalValues.  If the current config is unknown, it is probably
			// a desktop AIR run, and we should just let things take the course they always have.
			// If a config is known, then we want to use the new config ID suffix mechanism later.
			configID = TargetConfigurations.getTargetConfigID( UnitTester.cv );
			if( configID ){
				trace( "CompareBitmap: No ConditionalValues found.  configID is " + configID.toString() );
			}else{
				trace( "CompareBitmap: No ConditionalValues found.  configID is " + configID );
			}
		}

		if( url == null ){
			if( cv == null ){
				throw new Error("Found no url on the CompareBitmap for test case " + testCase.testID);
			}else{
				throw new Error("Found no url on the ConditionalValue for test case " + testCase.testID + ", ConditionalValue: " + cv.toString());
			}
		}

		// See if url ends with .png.  If not, create a file name.
		if( url.lastIndexOf( ".png" ) != url.length - 4 ){			      
			// Add a path separator if necessary.
			if( url.lastIndexOf( "/" ) != url.length - 1 ){
				url += "/";
			}		

			// Decide on a file name.
			if( conditionalValues ){
				// If we ended up with a matching CV, ask it to create a file name.
				// Otherwise, go with the test ID.
				// Keep this path alive until (if ever) ConditionalValues in CompareBitmaps have all been removed.
				if(cv){
					trace( "CompareBitmap: Asking the ConditionalValue to create the file name." );
					url += cv.createFilename( testCase.testID );
				} else {
					trace( "CompareBitmap: Creating the file name from the testID." );
					url += testCase.testID + ".png";
				}
			}else if( configID ){
				// We have no ConditionalValues and we're running a known config,
				// so use the config id in the suffix.
				trace( "CompareBitmap: Creating the file name from the configID." );
				url += testCase.testID + "@" + configID + ".png";
			}else{
				trace( "There is no file name, there are no Conditional Values, and there is no configID.  There's not much we can do now, is there?" );
			}
		}
				
		if (url != null && url.indexOf ("$testID") != -1) { 
			trace ("Replacing $testID with " + UnitTester.currentTestID);
			url = url.replace ("$testID", UnitTester.currentTestID);
			trace ("result 2: " + url);
		}

		if (url == null)
			trace ("URL was null at execute time");

		if (commandconnection)
			commandconnection.client = this;

		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			return true;
		}

		this.root = root;
		this.context = context;
		this.testResult = testResult;

		if (UnitTester.createBitmapReferences)
		{
			if (UnitTester.checkEmbeddedFonts)
			{
				if (!checkEmbeddedFonts(actualTarget))
				{
					testResult.doFail ("Target " + actualTarget + " is using non-embedded or advanced anti-aliased fonts");	
					return true;
				}
			}

			writeBaselines(actualTarget);
			return false;
		}
		else
		{
			readPNG();
			return false;
		}

	}

	private function getTargetSize(target:DisplayObject):Point
	{
		var width:Number;
		var height:Number;

    	try
    	{    		
    		width = target["getUnscaledWidth"]() * Math.abs(target.scaleX) * target.root.scaleX;
    		height = target["getUnscaledHeight"]() * Math.abs(target.scaleY) * target.root.scaleY;
		}
		catch(e:ReferenceError)
		{
			width = target.width * target.root.scaleX;
			height = target.height * target.root.scaleY;
		}
		return new Point(width, height);
	}

	// Given a displayObject, sets up the screenBits.
	private function getScreenBits(target:DisplayObject):void{
		try 
		{
			if (!stageText) {
				var targetSize:Point = getTargetSize(target);
				var stagePt:Point = target.localToGlobal(new Point(0, 0));
            			var altPt:Point = target.localToGlobal(targetSize);
            			stagePt.x = Math.min(stagePt.x, altPt.x);
            			stagePt.y = Math.min(stagePt.y, altPt.y);
				screenBits = new BitmapData(targetSize.x, targetSize.y);
				screenBits.draw(target.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
			} else {

				trace ("Using stagetext");
				try { 
					var tmpbm:BitmapData = target["textDisplay"]["captureBitmapData"]();
					screenBits = new BitmapData(tmpbm.rect.width, tmpbm.rect.height, true, 0xFFFFFFFF);
					screenBits.draw (tmpbm, new Matrix());

				} catch (e:Error) {
					trace ("Tried for StageText bitmap data, but it failed");
					trace (e.getStackTrace());
				}

			}
		}
		catch (se:SecurityError)
		{
			UnitTester.hideSandboxes();
			try
			{
				screenBits.draw(target.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
			}
			catch (se2:Error)
			{
				try 
				{
					// if we got a security error and ended up here, assume we're in the
					// genericLoader loads us scenario
					screenBits.draw(target.root, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
				}
				catch (se3:Error)
				{
				}
			}
			UnitTester.showSandboxes();
			var sb:Array = UnitTester.getSandboxBitmaps();
			var n:int = sb.length;
			for (var i:int = 0; i < n; i++)
			{
				mergeSandboxBitmap(target, stagePt, screenBits, sb[i]);
			}
		}
		catch (e:Error)
		{
			testResult.doFail (e.getStackTrace());	
		}
	}

	private var MAX_LC:int = 12000;
	private var screenBits:BitmapData;
	private var baselineBits:BitmapData;
	
	private var compareVal:Object;

	public function comparePNG(target:DisplayObject):Boolean 
	{ 
		if (UnitTester.checkEmbeddedFonts)
		{
			if (!checkEmbeddedFonts(target))
			{
				testResult.doFail ("Target " + target + " is using non-embedded or advanced anti-aliased fonts");	
				return true;
			}
		}

		if (!reader.content)
		{
			testResult.doFail ("baseline image not available");
			return true;
		}

		getScreenBits(target);

		try
		{
			baselineBits = new BitmapData(reader.content.width, reader.content.height);
			baselineBits.draw(reader.content, new Matrix());

			compareVal = baselineBits.compare (screenBits);

			if (compareVal is BitmapData && numColorVariances) {
				compareVal = compareWithVariances(compareVal as BitmapData)
			}

			if (compareVal != 0)
			{
				trace ("compare returned" + compareVal);
				
				var req:URLRequest = new URLRequest();
				if (UnitTester.isApollo) 
				{
					req.url = encodeURI2(CompareBitmap.adjustPath (url));
				} 
				else
				{
					req.url = url;
					var base:String = normalizeURL(context.application.url);
					base = base.substring(0, base.lastIndexOf("/"));
					while (req.url.indexOf("../") == 0)
					{
						base = base.substring(0, base.lastIndexOf("/"));
						req.url = req.url.substring(3);
					}
					
					req.url = encodeURI2(base + "/" + req.url);
				}
								
				req.url += ".xml";
				xmlreader = new URLLoader();
				xmlreader.addEventListener(Event.COMPLETE, readXMLCompleteHandler);
				xmlreader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, readErrorHandler);
				xmlreader.addEventListener(IOErrorEvent.IO_ERROR, readXMLIOErrorHandler);
				xmlreader.load (req);	
				return false;
			}
		}
		catch (e:Error) 
		{ 
			testResult.doFail (e.getStackTrace());	
		}
		return true;
	}
	
	private function readXMLCompleteHandler(event:Event):void
	{
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		var s:String = getDisplayListXML(actualTarget).toXMLString();
		if (s !== xmlreader.data)
		{
			testResult.doFail ("compare returned" + compareVal, absolutePathResult(url) + ".bad.png");

			if (useRemoteDiffer)
			{
				sendImagesToDiffer();
			}
			else if (fileSuffix != "") 
			{ 
				writeBaselines (actualTarget);
			}
		else
			stepComplete();
	}

	private function readXMLIOErrorHandler(event:Event):void
	{
		if (useRemoteDiffer)
		{
			sendImagesToDiffer();
		} 
		else if (fileSuffix != "") 
		{ 
			testResult.doFail ("compare returned" + compareVal, absolutePathResult(url) + ".bad.png");
			var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
			writePNG (actualTarget);
		}	
	}
		
	private function mergeSandboxBitmap(target:DisplayObject, pt:Point, bm:BitmapData, obj:Object):void
	{
		var targetSize:Point = getTargetSize(target);
		var sbm:BitmapData = new BitmapData(obj.width, obj.height);
		var srcRect:Rectangle = new Rectangle(0, 0, obj.width, obj.height);
		sbm.setPixels(srcRect, obj.bits);
		var targetRect:Rectangle = new Rectangle(pt.x, pt.y, targetSize.x, targetSize.y);
		var sbRect:Rectangle = new Rectangle(obj.x, obj.y, obj.width, obj.height);
		var area:Rectangle = targetRect.intersection(sbRect);
		if (area)
			bm.copyPixels(sbm, srcRect, target.globalToLocal(area.topLeft));
	}

	private function sendImagesToDiffer():void
	{
		UnitTester.callback = stringifyScreen;
	}

	private var ba:ByteArray;
	private function stringifyScreen():void
	{
		ba = screenBits.getPixels(screenBits.rect);
		ba.position = 0;
		connection.send("_ImageDiffer", "startScreenData", screenBits.width, screenBits.height, ba.length, UnitTester.currentTestID, UnitTester.currentScript);
		UnitTester.callback = sendScreen;
	}

	private function sendScreen():void
	{
		if (ba.position + MAX_LC < ba.length)
		{
			connection.send("_ImageDiffer", "addScreenData", stringify(ba));
			UnitTester.callback = sendScreen;
		}
		else
		{
			connection.send("_ImageDiffer", "addScreenData", stringify(ba));
			UnitTester.callback = stringifyBase;
		}
	}

	private function stringifyBase():void
	{
		ba = baselineBits.getPixels(baselineBits.rect);
		ba.position = 0;
		connection.send("_ImageDiffer", "startBaseData", baselineBits.width, baselineBits.height, ba.length);
		UnitTester.callback = sendBase;
	}

	private function sendBase():void
	{
		if (ba.position + MAX_LC < ba.length)
		{
			connection.send("_ImageDiffer", "addBaseData", stringify(ba));
			UnitTester.callback = sendBase;
		}
		else
		{
			connection.send("_ImageDiffer", "addBaseData", stringify(ba));
			connection.send("_ImageDiffer", "compareBitmaps");
		}
	}

	private function stringify(ba:ByteArray):String
	{
		var n:int = Math.min(ba.length - ba.position, MAX_LC);
		var arr:Array = [];
		for (var i:int = 0; i < n; i++)
		{
			var b:int = ba.readUnsignedByte();
			arr.push(b.toString(16))
		}
		return arr.toString();
	}

	private function readCompleteHandler(event:Event):void
	{
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		if (comparePNG(actualTarget))
			stepComplete();
	}

	private function readErrorHandler(event:Event = null):void
	{
		var failString:String = "baseline image could not be read.";

		failString += "  Creating image file as a .bad.png.";
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		getScreenBits(actualTarget);
		writePNG(actualTarget);
		testResult.doFail ( failString );
		stepComplete();
	}

	/**
	* Read a file and return a ByteArray that we can feed into reader (a Loader).
	**/
	public function loadFileBytes( file:File ):ByteArray{
				
		var fileStream:FileStream = new FileStream();
		var file:File;
		var ba:ByteArray = new ByteArray();
		var bytesRead:int = 0;
		var bytesAvail:int = 0;
		
		fileStream.open(file, FileMode.READ);
		bytesAvail = fileStream.bytesAvailable;
		
		while( bytesAvail > 0 ){
			fileStream.readBytes(ba, bytesRead, bytesAvail);
			bytesAvail = fileStream.bytesAvailable;
		}
		
		fileStream.close();

		return ba;
	}


	public function readPNG():void
	{
		var req:URLRequest = new URLRequest();
		var ba:ByteArray = null;
		var file:File;
		
		// If iOS and AIR, let's try using file I/O instead of loader stuff. AIR on devices can be a pain with the url stuff.
		if( UnitTester.isApollo && (UnitTester.cv.os.toLowerCase() == DeviceNames.IOS.toLowerCase()) ){
			// Trim the leading ../ if we have it.
			if ( url.indexOf ("../") == 0 ){
				url = url.substring (3);
			}
			
			file = File.documentsDirectory.resolvePath( url );
			
			if( !file.exists ){
				readErrorHandler();
				return;
			}
			
			ba = loadFileBytes( file );
			reader.loadBytes( ba );
		}else{		
			if (UnitTester.isApollo)
			{
				req.url = encodeURI2(CompareBitmap.adjustPath (url));
			}
			else
			{
				req.url = url;
				var base:String = normalizeURL(context.application.url);
				base = base.substring(0, base.lastIndexOf("/"));
				while (req.url.indexOf("../") == 0)
				{
					base = base.substring(0, base.lastIndexOf("/"));
					req.url = req.url.substring(3);
				}
				req.url = encodeURI2(base + "/" + req.url);
			}
		}
		
		reader = new Loader();
		reader.contentLoaderInfo.addEventListener(Event.COMPLETE, readCompleteHandler);
		reader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, readErrorHandler);
		reader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, readErrorHandler);
		//	req.url = encodeURI2(url);
		// }
		
		trace ("readPNG:requesting url: " + req.url);			
		reader.load (req);	
		
	}


	public static var adjustPath:Function = function(url:String):String { return url; };




    public function getPngByteArray(target:DisplayObject, bitmapData:BitmapData):ByteArray 
	{
		// add png headers
		if (UnitTester.createBitmapReferences)
		{
			if (stageText == false) 
			{
				var targetSize:Point = getTargetSize(target);
				var stagePt:Point = target.localToGlobal(new Point(0, 0));
       	     			var altPt:Point = target.localToGlobal(targetSize);

            			stagePt.x = Math.min(stagePt.x, altPt.x);
            			stagePt.y = Math.min(stagePt.y, altPt.y);
				bitmapData = new BitmapData(targetSize.x, targetSize.y);
				bitmapData.draw(target.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));
			} else {

				trace ("stageText value: " + stageText);
				try { 
					bitmapData = target["textDisplay"]["captureBitmapData"]();
					trace ("success asking StageText for bitmap data");
				} catch (e:Error) {
					trace ("Tried for StageText bitmap data, but it failed");
					trace (e.getStackTrace());
				}

			}

		} 
		var png:MustellaPNGEncoder = new MustellaPNGEncoder();
		var ba:ByteArray = png.encode (bitmapData);

		return ba;
	}


	public function writeBaselines(target:DisplayObject, writeDisplayList:Boolean = true):void 
	{
		var req:URLRequest = new URLRequest();
		writer = new URLLoader();
		req.method = "POST";
		
		/**
		 * either we got called here to write new baselines
		 * or to save a .bad.png for investigation
		 * in addition, with failures, we upload baseline and failure to a server
		 */
		if (UnitTester.createBitmapReferences) 
		{	
			fileSuffix = "";
		} 
		
		
		if (writeDisplayList)
		{
			var s:String = getDisplayListXML(target).toXMLString();
			// request data goes on the URL Request
			req.data = s;
			
			req.contentType = "text/xml";
			if (UnitTester.isApollo) 
			{ 
				req.url = encodeURI2(UnitTester.bitmapServerPrefix + adjustWriteURI(adjustPath(url))) + fileSuffix + ".xml";
			} else 
			{
				req.url = encodeURI2(UnitTester.bitmapServerPrefix + absolutePath(url)) + fileSuffix + ".xml";
			}
			trace ("writing url: " + req.url);
			writer.addEventListener(Event.COMPLETE, writeXMLCompleteHandler);
			writer.addEventListener(SecurityErrorEvent.SECURITY_ERROR, writeErrorHandler);
			writer.addEventListener(IOErrorEvent.IO_ERROR, writeErrorHandler);
			
			writer.load (req);	
		}
	}
	
	private function writeXMLCompleteHandler(event:Event):void
	{
		var actualTarget:DisplayObject = DisplayObject(context.stringToObject(target));
		writePNG(actualTarget);
	}
	
	private function writePNG(target:DisplayObject):void
	{
		var req:URLRequest = new URLRequest();
		writer = new URLLoader();
		req.method = "POST";
		
		var ba:ByteArray = getPngByteArray(target, screenBits);			
		trace ("image size: " + ba.length);

		if( UnitTester.createBitmapReferences ){
			fileSuffix = "";
		}

		if( UnitTester.writeBaselinesToDisk ){
			// context.testDir: mobile/components/Button/properties/
			// url: ../properties/baselines/button_android_test1_CustomName.png
			var writePath:String = createWritePath( context.testDir, url + fileSuffix );
			var deviceWritePath:String = UnitTester.mustellaWriteLocation + "/" + writePath;
//			trace("*******deviceWritePath = " + deviceWritePath); 
			var hostWritePath:String = writePath;
			var file:File = new File ( deviceWritePath );
			var fileStream:FileStream = new FileStream();
			var hostCommand:String;

			// open() opens synchronously, so we don't have to (and can't) use listeners.
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(ba);
			fileStream.close();

			// Tell the host machine to copy the baseline image.
			// Also, give it a URL with test info. to use when sending it to flexqa01's baseline server.
			if( UnitTester.cv.os.toLowerCase() == DeviceNames.ANDROID.toLowerCase() ||
				UnitTester.cv.os.toLowerCase() == DeviceNames.IOS.toLowerCase() ||
				UnitTester.cv.os.toLowerCase() == DeviceNames.QNX.toLowerCase() ){
				hostCommand = "CopyDeviceFile: FROM=" + deviceWritePath + " TO=" + hostWritePath;
				
				// If this is about creating bitmaps, skip the upload, we're done
				if ( !UnitTester.createBitmapReferences ){
					hostCommand += " SCREENURL=" + (UnitTester.urlAssemble ("screen", context.testDir, context.scriptName, this.testResult.testID, UnitTester.run_id));
					hostCommand += " BASELINEURL=" + (UnitTester.urlAssemble ("baseline", context.testDir, context.scriptName, this.testResult.testID, UnitTester.run_id));
				}

				// Trace statements are parsed by the host.
				trace( hostCommand );
			}

			if (UnitTester.createBitmapReferences){
				stepComplete();
			}

			return;
		}else{
			trace("AIR CompareBitmap is called, but we're not writing to disk.  This is wrong.");
		}
    }

	private function adjustWriteURI(url:String):String
	{
		var base:String = null;
		
		// For iOS, do something different.
		if( UnitTester.isApollo && (UnitTester.cv.os != null) && (UnitTester.cv.os.toLowerCase() == DeviceNames.IOS.toLowerCase()) ){
			base = url;
			
			// Trim the leading ../ if we have it.
			if ( base.indexOf ("../") == 0 ){
				base = base.substring (3);
			}
			
			base = File.documentsDirectory.resolvePath(base).nativePath;
			
			return base;
		}else{
			var pos:int = url.indexOf("file:///");
			if (pos != 0)
			{
				return url;
			}
			url = url.substring(8);
			pos = url.indexOf("|");

			if (pos != 1)
			{
				return url;
			}

			var drive:String = url.substring(0, 1);
			drive = drive.toLowerCase();
			return drive + ":" + url.substring(2);
		}
	}

	/**
	 * Called by writePNG when, for example, we're testing on Android.
	 * firstPart:	mobile/components/Button/properties/
	 * secondPart:	../properties/baselines/button_android_test1_CustomName.png
	 **/
	private function createWritePath( firstPart:String, secondPart:String ):String{
		var ret:String = "tests/" + firstPart.substring( 0, firstPart.lastIndexOf( "/" ) );
		
		var removeMe:String = ret.substring( ret.lastIndexOf( "/" ), ret.length ); // "properties"
		ret += secondPart.substring( secondPart.indexOf( removeMe ) + removeMe.length, secondPart.length );

		trace("createWritePath returning " + ret);
		return ret;
	}

	private var screenDone:Boolean = false;
	private var baselineDone:Boolean = false;

	private function writeCompleteHandler(event:Event):void
	{
		trace("baseline write successful " + event);
		stepComplete();
	}

	private function uploadCompleteHandler(event:Event):void
	{
		trace("screen image upload successful " + event);
		screenDone = true;
		checkForStepComplete();
	}

	private function upload2CompleteHandler(event:Event):void
	{
		trace("baseline image upload successful " + event);
		baselineDone = true;
		checkForStepComplete();
	}

	private function writeErrorHandler(event:Event):void
	{
		testResult.doFail ("error on baseline write: " + event);
		trace("Image baseline write failed " + event);
		if (UnitTester.createBitmapReferences)
			stepComplete();
	}
	private function uploadErrorHandler(event:Event):void
	{
		testResult.doFail ("error on baseline write: " + event);
		trace("Image screen upload failed " + event);
		screenDone = true;
		checkForStepComplete();
	}

	private function upload2ErrorHandler(event:Event):void
	{
		testResult.doFail ("error on baseline write: " + event);
		trace("Image baseline upload failed " + event);
		baselineDone = true;
		checkForStepComplete();
	}

	private function checkForStepComplete():void
	{

		if (baselineDone && screenDone)
			stepComplete();


	}

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = (UnitTester.createBitmapReferences) ? "CreateBitmap: " : "CompareBitmap";
		if (target)
			s += ": target = " + target;
		if (url)
			s += ", url = " + url;
		return s;
	}

	private function absolutePathResult(url:String):String
	{ 
		var base:String = null;

		if( UnitTester.isApollo && (UnitTester.cv.os != null) && (UnitTester.cv.os.toLowerCase() == DeviceNames.IOS.toLowerCase()) ){
			base = url;
			
			// Trim the leading ../ if we have it.
			if ( base.indexOf ("../") == 0 ){
				base = base.substring (3);
			}
			
			base = File.documentsDirectory.resolvePath(base).nativePath;
			
		} else if( UnitTester.isApollo && (UnitTester.cv.os != null) && (UnitTester.cv.os.toLowerCase() == DeviceNames.ANDROID.toLowerCase()) ){

			/// code doing what it does now: 
				
			var fPath:String = createWritePath( context.testDir, url + fileSuffix );

			/// clean up 
			if (fPath.indexOf ("tests/") == 0)
				fPath = fPath.substring (5);

			/// clean up 
			/// it probably has the .bad.png suffix
			if (fPath.indexOf (".bad.png") > 0)
				fPath = fPath.substring (0, fPath.length-".bad.png".length);
				
			base = fPath;

		}else{
			if (UnitTester.isApollo) {
				base = adjustWriteURI(adjustPath (url));
			}else{
				base = context.application.url;
			}

			base = normalizeURL(base);
			base = base.substring (base.indexOf ("mustella/tests")+14);

			if (!UnitTester.isApollo) {
				base = base.substring(0, base.lastIndexOf("/"));
			
				var tmp:String = url;

				while (tmp.indexOf("../") == 0){
						base = base.substring(0, base.lastIndexOf("/"));
						tmp = tmp.substring(3);
				}

				base += "/" + tmp;
			}
		}
		
		return base;
	}

	
	private function absolutePath(url:String):String
	{
		var swf:String = normalizeURL(root.loaderInfo.url);

		var pos:int = swf.indexOf("file:///");
		if (pos != 0)
		{
			trace("WARNING: unexpected swf url format, no file:/// at offset 0");
			return url;
		}
		swf = swf.substring(8);
		pos = swf.indexOf("|");
		if (pos != 1)
		{
			trace("WARNING: unexpected swf url format, no | at offset 1 in: " + swf);
			// assume we're on a mac or other unix box, it will do no harm
			return "/" + swf.substring(0, swf.lastIndexOf ("/")+1)  + url;
		}

		var drive:String = swf.substring(0, 1);
		drive = drive.toLowerCase();
		return drive + ":" + swf.substring(2, swf.lastIndexOf("/") + 1) + url;
	}


        public static function normalizeURL(url:String):String
        {
        	var results:Array = url.split("/[[DYNAMIC]]/");
        	return results[0];
        }


	public function keepGoing():void
	{
		trace("keepgoing", url, hasEventListener("stepComplete"));
		stepComplete();
	}

	private function encodeURI2(s:String):String
	{
		var pos:int = s.lastIndexOf("/");
		if (pos != -1)
		{
			var fragment:String = s.substring(pos + 1);
			s = s.substring(0, pos + 1);
			fragment= encodeURIComponent(fragment);
			s = s + fragment;
		}
		return s;
	}

	private function compareWithVariances(bm:BitmapData):Object
	{

		var allowed:int = numColorVariances * UnitTester.pixelToleranceMultiplier;
		var n:int = bm.height;
		var m:int = bm.width;

		for (var i:int = 0; i < n; i++)
		{
			for (var j:int = 0; j < m; j++)
			{
				var pix:int = bm.getPixel(j, i);
				if (pix)
				{
					if(!ignoreMaxColorVariance)
					{
						var red:int = pix >> 16 & 0xff;
						var green:int = pix >> 8 & 0xff;
						var blue:int = pix & 0xff;
						if (red & 0x80)
							red = 256 - red;
						if (blue & 0x80)
							blue = 256 - blue;
						if (green & 0x80)
							green = 256 - green;
						if (red > maxColorVariance ||
							blue > maxColorVariance ||
							green > maxColorVariance)
						{
							return bm;
						}
					}
					allowed--;
					if (allowed < 0)
					{
						return bm;
					}
				}
			}
		}
		return 0;
	}

	private function checkEmbeddedFonts(target:Object):Boolean
	{
		if ("rawChildren" in target)
			target = target.rawChildren;

		if (target is TextField)
		{
			if (target.embedFonts == false)
				return false;
			if (target.antiAliasType == "advanced")
				return false;
			return true;
		}
		else if ("numChildren" in target)
		{
			var n:int = target.numChildren;
			for (var i:int = 0; i < n; i++)
			{
				if (!checkEmbeddedFonts(target.getChildAt(i)))
					return false;
			}
		}
		
		return true;
	}

	override protected function stepComplete():void 
	{ 

                if (baselineBits != null)
                        baselineBits.dispose();
                if (screenBits != null)
                        screenBits.dispose();


		reader=null;
		writer=null;
		
		super.stepComplete();


	}
	
	/****** DisplayList Comparision ******/
	protected function getDisplayListProperties(d:DisplayObject, noMask:Boolean = false):XML
	{
		var xml:XML;
		var n:int;
		var i:int;
		var childXML:XML;
		var s:String = getQualifiedClassName(d);
		s = s.replace("::", ".");
		xml = new XML("<" + s + "/>");
		s = d.transform.concatenatedColorTransform.toString();
		if (s != identityColorTransform)
			xml.@concatenatedColorTransform = s;
		if (d.transform.matrix)
		{
			s = d.transform.matrix.toString();
			if (s != identityMatrix)
			{
				if (s.indexOf("(a=1, b=0, c=0, d=1, ") == -1)
					xml.@matrix = s;
			}
		}
		else
		{
			s = d.transform.matrix3D.rawData.toString();
			xml.@matrix3D = s;
		}
		if (d.x != 0)
			xml.@x = d.x;
		if (d.y != 0)
			xml.@y = d.y;
		xml.@width = d.width;
		xml.@height = d.height;
		if (xml.visible == false)
			xml.@visible = "false";
		if (d.mask && !noMask)
		{
			xml.mask = <mask/>;
			childXML = getDisplayListProperties(d.mask, true);
			xml.mask.appendChild = childXML;
		}
		if (d.scrollRect)
		{
			s = d.scrollRect.toString();
			xml.@scrollRect = s;
		}
		if (d.blendMode && d.blendMode != "normal")
			xml.@blendMode = d.blendMode;
		if (d.cacheAsBitmap)
			xml.@cacheAsBitmap = "true";
		if (d.filters && d.filters.length > 0)
		{
			s = d.filters.toString();
			xml.@filters = s;
		}
		if (d.opaqueBackground)
			xml.@opaqueBackground = "true";
		if (d.scale9Grid)
		{
			s = d.scale9Grid.toString();
			xml.@scale9Grid = s;
		}
		if (d is TextField)
		{
			xml.htmlText = TextField(d).htmlText;
		}
		if (d is Loader && Loader(d).contentLoaderInfo.contentType.indexOf("image") != -1)
		{
			s = Loader(d).contentLoaderInfo.url;
			s = s.substring(s.lastIndexOf("/") + 1);
			xml.@loaderbitmap = s;
		}
		if (d is TextLine)
		{
			var tl:TextLine = TextLine(d);
			xml.@ascent = tl.ascent;
			xml.@descent = tl.descent;
			xml.@atomCount = tl.atomCount;
			xml.@hasGraphicElement = tl.hasGraphicElement;
			if (tl.textBlock)
			{
				var tb:TextBlock = TextLine(d).textBlock;
				var ce:ContentElement = tb.content;
				s = ce.rawText.substr(tl.textBlockBeginIndex, tl.rawTextLength);
				xml.@text = s;
			}
		}
		
		if (d is IRawChildrenContainer)
		{
			var rawChildren:IChildList = IRawChildrenContainer(d).rawChildren;
			n = rawChildren.numChildren;
			for (i = 0; i < n; i++)
			{
				childXML = getDisplayListProperties(rawChildren.getChildAt(i));
				xml.appendChild(childXML);				
			}
		}
		else if (d is DisplayObjectContainer)
		{
			var doc:DisplayObjectContainer = d as DisplayObjectContainer;
			n = doc.numChildren;
			for (i = 0; i < n; i++)
			{
				childXML = getDisplayListProperties(doc.getChildAt(i));
				xml.appendChild(childXML);				
			}
		}
		return xml;
	}
	
	// scan entire display list, but only dump objects intersecting target
	protected function getDisplayListXML(target:DisplayObject):XML
	{
		var n:int;
		var i:int;
		var child:DisplayObject;
		var childXML:XML;
		
		var doc:DisplayObjectContainer = DisplayObjectContainer(target.root);
		var xml:XML = <DisplayList />;
		if (doc is IRawChildrenContainer)
		{
			var rawChildren:IChildList = IRawChildrenContainer(doc).rawChildren;
			n = rawChildren.numChildren;
			for (i = 0; i < n; i++)
			{
				child = rawChildren.getChildAt(i);
				if (target.hitTestObject(child))
				{
					childXML = getDisplayListProperties(child);
					xml.appendChild(childXML);	
				}
			}
		}
		else 
		{
			n = doc.numChildren;
			for (i = 0; i < n; i++)
			{
				child = doc.getChildAt(i);
				if (target.hitTestObject(child))
				{
					childXML = getDisplayListProperties(child);
					xml.appendChild(childXML);									
				}
			}
		}
		return xml;
	}
}

}
