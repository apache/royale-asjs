package
{
[RemoteClass(alias='ASDocClassTags')]
public class ASDocClassTags
{
    public static const key:String = "tagName:string;values:object";

    private var _tagName:String;
    [Bindable("__NoChangeEvent__")]
    public function get tagName():String
    {
        return _tagName;
    }
    public function set tagName(__v__:String):void
    {
        _tagName = __v__;
    }

    private var _values:Array;
    [Bindable("__NoChangeEvent__")]
    public function get values():Array
    {
        return _values;
    }
    public function set values(__v__:Array):void
    {
        _values = __v__;
    }

}
}
