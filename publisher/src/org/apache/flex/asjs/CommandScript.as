package org.apache.flex.asjs
{

import flash.utils.Dictionary;

import mx.utils.StringUtil;

import org.apache.flex.asjs.interfaces.IExecutable;

public class CommandScript implements IExecutable
{

	//----------------------------------------------------------------------
	//
	//    Constructor
	//
	//----------------------------------------------------------------------
	
	public function CommandScript() 
	{
		this.scripts = new Dictionary();
		
		_commandLine = new CommandLine();
	}
	
	
	
	//----------------------------------------------------------------------
	//
	//    Variables
	//
	//----------------------------------------------------------------------
	
	private var _commandLine:CommandLine;
	
	
	
	//----------------------------------------------------------------------
	//
	//    Properties
	//
	//----------------------------------------------------------------------
	
	//----------------------------------
	//    scripts
	//----------------------------------
	
	public var scripts:Dictionary;
	
	
	
	//----------------------------------------------------------------------
	//
	//    Methods
	//
	//----------------------------------------------------------------------
	
	//----------------------------------
	//    exec
	//----------------------------------
	
	public function exec(scriptName:String, params:Array = null):void
	{
		var script:String = scripts[scriptName];
		
		if (params)
			script = StringUtil.substitute(script, params);
		
		var command:String, commands:Array = script.split("\n");
			
		var n:int = commands.length - 1; // last line is always empty
		for (var i:int = 0; i < n; i++)
		{
			command = commands[i];
			
			trace("COMMAND: " + command);

			_commandLine.exec(commands[i] + "\n", null);
		}
	}
	
}
}