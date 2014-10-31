package vf2js.system
{

public interface ICapabilities
{
	function get language():String;
	
	function get os():String;
	
	function get playerType():String;
	
	function get screenDPI():Number;
	
	function get version():String;
}

}