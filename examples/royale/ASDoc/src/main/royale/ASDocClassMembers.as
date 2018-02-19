package
{
[RemoteClass(alias='ASDocClassMembers')]
public class ASDocClassMembers extends ASDocClassFunction
{
    public static const key:String = "bindable:object;deprecated:object;description:string;details:object;namespace:string;params:object;qname:string;return:string;tags:object;type:string";

    private var _params:Array;
    [Bindable("__NoChangeEvent__")]
    public function get params():Array
    {
        return _params;
    }
    public function set params(__v__:Array):void
    {
        _params = __v__;
    }

}
}
