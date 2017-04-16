package org.apache.flex.net.beads {
import org.apache.flex.core.IBead;
import org.apache.flex.core.IStrand;
import org.apache.flex.events.Event;
import org.apache.flex.events.IEventDispatcher;

COMPILE::SWF
public class CORSCredentialsBead {
    public function CORSCredentialsBead(withCredentials:Boolean = false) {
        trace("Only needed for JavaScript HTTP Server calls");
    }
}

/**
 *  Bead to allow passing on user authentication information in a XMLHttpRequest request.
 *
 *  If you don't use this bead any cross domain calls that require user authentication
 *  (via say basic authentication or cookies) will fail.
 *
 *  @productversion FlexJS 0.8
 */
COMPILE::JS
public class CORSCredentialsBead implements IBead {

    public function CORSCredentialsBead(withCredentials:Boolean = false) {
        this.withCredentials = withCredentials;
    }

    private var _strand:IStrand;

    /**
     *  Listen for a pre and post send event to modify if user credentials are passed.
     *
     *  @productversion FlexJS 0.8
     */
    public function set strand(value:IStrand):void {
        _strand = value;

        IEventDispatcher(_strand).addEventListener("preSend", preSendHandler);
        IEventDispatcher(_strand).addEventListener("postSend", postSendHandler);
    }

    /**
     *  Modify the HTTP request to pass credentials.
     *
     *  @productversion FlexJS 0.8
     */
    protected function preSendHandler(event:Event):void {
        (event.target.element as XMLHttpRequest).withCredentials = withCredentials;
    }

    /**
     *  Clean up event listeners.
     *
     *  @productversion FlexJS 0.8
     */
    protected function postSendHandler(event:Event):void {
        IEventDispatcher(_strand).removeEventListener("preSend", preSendHandler);
        IEventDispatcher(_strand).removeEventListener("postSend", preSendHandler);
    }

    private var _withCredentials:Boolean = false;

    /**
     *  Pass the user credentials or not.
     *
     *  @productversion FlexJS 0.8
     */
    public function get withCredentials():Boolean
    {
        return _withCredentials;
    }

    public function set withCredentials(value:Boolean):void
    {
        _withCredentials = value;
    }
}
}
