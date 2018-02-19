package
{
[RemoteClass(alias='ASDocClassEvents')]
public class ASDocClassEvents
{
    public static const key:String = "description:string;qname:string;tags:object;type:string";

    private var _type:String;
    [Bindable("__NoChangeEvent__")]
    public function get type():String
    {
        return _type;
    }
    public function set type(__v__:String):void
    {
        _type = __v__;
    }

    private var _description:String;
    [Bindable("__NoChangeEvent__")]
    public function get description():String
    {
        return _description;
    }
    public function set description(__v__:String):void
    {
        _description = __v__;
    }

    private var _qname:String;
    [Bindable("__NoChangeEvent__")]
    public function get qname():String
    {
        return _qname;
    }
    public function set qname(__v__:String):void
    {
        _qname = __v__;
    }

    private var _tags:Array;
    [Bindable("__NoChangeEvent__")]
    public function get tags():Array
    {
        return _tags;
    }
    public function set tags(__v__:Array):void
    {
        _tags = __v__;
    }

    private var _shortDescription:String;
    [Bindable("__NoChangeEvent__")]
    public function get shortDescription():String
    {
        return _shortDescription;
    }
    public function set shortDescription(__v__:String):void
    {
        _shortDescription = __v__;
    }
    
    private var _attributes:Array;
    [Bindable("__NoChangeEvent__")]
    public function get attributes():Array
    {
        return _attributes;
    }
    public function set attributes(__v__:Array):void
    {
        _attributes = __v__;
    }
    
    private var _typehref:String;
    [Bindable("__NoChangeEvent__")]
    public function get typehref():String
    {
        return _typehref;
    }
    public function set typehref(__v__:String):void
    {
        _typehref = __v__;
    }
    
    private var _ownerhref:String;
    [Bindable("__NoChangeEvent__")]
    public function get ownerhref():String
    {
        return _ownerhref;
    }
    public function set ownerhref(__v__:String):void
    {
        _ownerhref = __v__;
    }

}
}
