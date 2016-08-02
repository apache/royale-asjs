package org.apache.flex.geom
{
	public interface IMatrix
	{
		function get a():Number;
		function set a(value:Number):void;
		function get b():Number;
		function set b(value:Number):void;
		function get c():Number;
		function set c(value:Number):void;
		function get d():Number;
		function set d(value:Number):void;
		function get tx():Number;
		function set tx(value:Number):void;
		function get ty():Number;
		function set ty(value:Number):void;
		function clone():IMatrix
	}
}