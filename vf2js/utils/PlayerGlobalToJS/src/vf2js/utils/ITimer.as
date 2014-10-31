package vf2js.utils
{

public interface ITimer
{
	function get delay():Number;
	function set delay(value:Number):void;

	function reset():void;
	function start():void;
	function stop():void;
}

}