package
{
[RemoteClass(alias='ASDocClassAccessor')]
public class ASDocClassAccessor extends ASDocClassFunction
{
    public static const key:String = "access:string;bindable:object;deprecated:object;description:string;details:object;namespace:string;qname:string;return:string;tags:object;type:string";

    private var _access:Array;
    [Bindable("__NoChangeEvent__")]
    public function get access():Array
    {
        return _access;
    }
    public function set access(__v__:Array):void
    {
        _access = __v__;
    }

}
}
