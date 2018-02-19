package
{
public class ASDocClassFunction extends ASDocClassEvents
{
    
    private var _bindable:Array;
    [Bindable("__NoChangeEvent__")]
    public function get bindable():Array
    {
        return _bindable;
    }
    public function set bindable(__v__:Array):void
    {
        _bindable = __v__;
    }

    private var _details:Array;
    [Bindable("__NoChangeEvent__")]
    public function get details():Array
    {
        return _details;
    }
    public function set details(__v__:Array):void
    {
        _details = __v__;
    }
    
    private var _deprecated:Array;
    [Bindable("__NoChangeEvent__")]
    public function get deprecated():Array
    {
        return _deprecated;
    }
    public function set deprecated(__v__:Array):void
    {
        _deprecated = __v__;
    }
    
    private var _namespace:String;
    [Bindable("__NoChangeEvent__")]
    public function get namespace():String
    {
        return _namespace;
    }
    public function set namespace(__v__:String):void
    {
        _namespace = __v__;
    }
    
    private var _return:String;
    [Bindable("__NoChangeEvent__")]
    public function get return():String
    {
        return _return;
    }
    public function set return(__v__:String):void
    {
        _return = __v__;
    }

    private var _returnhref:String;
    [Bindable("__NoChangeEvent__")]
    public function get returnhref():String
    {
        return _returnhref;
    }
    public function set returnhref(__v__:String):void
    {
        _returnhref = __v__;
    }
}
}
