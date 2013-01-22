package org.apache.flex.asjs
{

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.EventDispatcher;
import flash.events.NativeProcessExitEvent;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.system.Capabilities;

import mx.utils.StringUtil;

import org.apache.flex.asjs.events.CommandLineEvent;
import org.apache.flex.asjs.interfaces.IExecutable;

[Event(name="exit", type="org.apache.flex.asjs.events.CommandLineEvent")]

public class CommandLine extends EventDispatcher implements IExecutable
{
	
	//----------------------------------------------------------------------
	//
	//    Constructor
	//
	//----------------------------------------------------------------------
	
	public function CommandLine() {}

	
	
	//----------------------------------------------------------------------
	//
	//    Variables
	//
	//----------------------------------------------------------------------

	private var _nativeProcess:NativeProcess;
	
	private var _nativeProcessStartupInfo:NativeProcessStartupInfo;
	
	
	
	//----------------------------------------------------------------------
	//
	//    Methods
	//
	//----------------------------------------------------------------------
	
	//----------------------------------
	//    exec
	//----------------------------------

	public function exec(command:String = "", params:Array = null):void
	{
		if (params)
			command = StringUtil.substitute(command, params);
		
		if (!_nativeProcess)
			init();
		
		if (!_nativeProcess.running)
			_nativeProcess.start(_nativeProcessStartupInfo);
		
		_nativeProcess.standardInput.writeUTFBytes(command);
	}
	
	//----------------------------------
	//    getCommandExecutablePaths
	//----------------------------------
	
	public function getCommandExecutable():File
	{
		var commandExecutableName:String;
		var commandExecutablePath:String;
		
		if (Capabilities.os.indexOf("Windows") != -1)
		{
			commandExecutableName = "cmd.exe";
			
			commandExecutablePath = "c:\\" + commandExecutableName;
		}
		else
		{
			commandExecutableName = "bash";
			
			commandExecutablePath = "/bin/" + commandExecutableName;
		}
		
		return new File().resolvePath(commandExecutablePath);
	}
	
	//----------------------------------
	//    init
	//----------------------------------
	
	private function init():void
	{
		if (NativeProcess.isSupported)
		{
			_nativeProcess = new NativeProcess();
			_nativeProcess.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, errorHandler);
			_nativeProcess.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, outputHandler);
			_nativeProcess.addEventListener(NativeProcessExitEvent.EXIT, exitHandler);

			_nativeProcessStartupInfo = new NativeProcessStartupInfo();
			_nativeProcessStartupInfo.executable = getCommandExecutable();
			
			_nativeProcess.start(_nativeProcessStartupInfo);
		}
		else
		{
			throw new Error("Application Error: NativeProcess is not supported.");
		}
	}
	
	
	
	//----------------------------------------------------------------------
	//
	//    Event handlers
	//
	//----------------------------------------------------------------------
	
	//----------------------------------
	//    errorHandler
	//----------------------------------
	
	public function errorHandler(event:ProgressEvent):void
	{
		trace("ERROR: " + _nativeProcess.standardError.readUTFBytes(_nativeProcess.standardError.bytesAvailable));
	}
	
	//----------------------------------
	//    exitHandler
	//----------------------------------
	
	public function exitHandler(event:NativeProcessExitEvent):void
	{
		if (event.exitCode == 0)
			dispatchEvent(new CommandLineEvent(CommandLineEvent.EXIT));
		else
			throw ("SOMETHING WENT WRONG WITH THE LAST COMMAND");
	}
	
	//----------------------------------
	//    outputHandler
	//----------------------------------
	
	public function outputHandler(event:ProgressEvent):void
	{
		trace(_nativeProcess.standardOutput.readUTFBytes(_nativeProcess.standardOutput.bytesAvailable));
	}
	
}
}