package vf2js.display
{

public interface IMovieClip
{
	function get currentFrame():int;
	
	function get framesLoaded():int;
	
	function get totalFrames():int;
	
	function nextFrame():void;
	
	function stop():void;
}

}