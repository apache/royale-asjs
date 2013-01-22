package org.apache.flex.asjs
{

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import mx.utils.StringUtil;

import org.apache.flex.asjs.events.CommandLineEvent;
import org.apache.flex.asjs.events.CommandScriptEvent;
import org.apache.flex.asjs.interfaces.IExecutable;

[Event(name="done", type="org.apache.flex.asjs.events.CommandScriptEvent")]

public class CommandScript extends EventDispatcher implements IExecutable
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
		_commandLine.addEventListener(CommandLineEvent.EXIT, commandlineExitHandler);
		
		chain = [];
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
	//    chain
	//----------------------------------
	
	public var chain:Array;
	
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
	
	public function exec(scriptName:String = "", params:Array = null):void
	{
		runScript();
	}
	
	
	//----------------------------------
	//    runScript
	//----------------------------------
	
	private function runScript():void
	{
		var chainItem:Array = chain.shift();
		
		var script:String = scripts[chainItem[0]];
		var params:Array = chainItem[1];
		
		if (params)
			script = StringUtil.substitute(script, params);
		
		var command:String, commands:Array = script.split("\n");
		
		commands.push("exit");
		
		var n:int = commands.length; // last line is always empty
		for (var i:int = 0; i < n; i++)
		{
			command = commands[i];
			
			_commandLine.exec(command + "\n", null);
		}
	}
	
	
	
	//----------------------------------------------------------------------
	//
	//    Event handlers
	//
	//----------------------------------------------------------------------
	
	//----------------------------------
	//    commandlineExitHandler
	//----------------------------------
	
	private function commandlineExitHandler(event:CommandLineEvent):void
	{
		if (chain.length > 0)
			runScript();
		else
			dispatchEvent(new CommandScriptEvent(CommandScriptEvent.DONE));
	}	
	
}
}