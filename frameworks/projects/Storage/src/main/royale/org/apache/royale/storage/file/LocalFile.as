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
package org.apache.royale.storage.file
{
COMPILE::SWF {
	import flash.filesystem.File;
}
COMPILE::JS {
}

/**
 * The File class provides access to a specific file on the device.
 */
COMPILE::SWF
public class LocalFile
{
	public static const documentsDirectory:String = "documentsDirectory";
	public static const dataDirectory:String = "dataDirectory";

	public function LocalFile(handle:Object=null)
	{
		_handle = handle as flash.filesystem.File;
	}

	private var _handle:flash.filesystem.File;

	public function get handle():flash.filesystem.File {
		return _handle;
	}

	static public function resolvePath(directory:String, filename:String):LocalFile {
		var root:File;
		if (directory == LocalFile.documentsDirectory) {
			root = File.documentsDirectory;
		}
		else if (directory == LocalFile.dataDirectory) {
			root = File.applicationStorageDirectory;
		}
		var result:LocalFile = new LocalFile(root.resolvePath(filename));
		return result;
	}
}

COMPILE::JS
public class LocalFile
{
	public static const documentsDirectory:String = cordova.file.documentsDirectory;
	public static const dataDirectory:String = cordova.file.dataDirectory;

	private var _handle:cordova.File;

	public function get handle():cordova.File {
		return _handle;
	}

	static public function resolvePath(directory:String, filename:String):LocalFile {
		var pathToFile = directory + filename;
		var result:File = new File();
		window.resolveLocalFileSystemURL(pathToFile, function(fileEntry) {
			fileEntry.file(function (file) {
				this.result._handle = file;
			})
		});
		return result;
	}
}

}
