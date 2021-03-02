package;

import motion.Actuate;
import openfl.display.Sprite;
import openfl.events.AsyncErrorEvent;
import openfl.events.MouseEvent;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import vlc.VLCVideo;
import openfl.display.Bitmap;
import openfl.Assets;

class Main extends Sprite
{
	
	
	private var netStream:NetStream;
	private var overlay:Sprite;
	// private var video:Video;
	
	var bitmap : Bitmap;
	
	public function new()
	{
		super ();
		var vlcVideo:VLCVideo = new VLCVideo("bbb.mp4");
		addChild(vlcVideo);
/* 		video = new Video ();
		addChild (video);
		
		var netConnection = new NetConnection ();
		netConnection.connect (null);
		
		netStream = new NetStream (netConnection);
		netStream.client = { onMetaData: client_onMetaData };
		netStream.addEventListener (AsyncErrorEvent.ASYNC_ERROR, netStream_onAsyncError);
		
		#if (js && html5)
		overlay = new Sprite ();
		overlay.graphics.beginFill (0, 0.5);
		overlay.graphics.drawRect (0, 0, 560, 320);
		overlay.addEventListener (MouseEvent.MOUSE_DOWN, overlay_onMouseDown);
		addChild (overlay);
		
		netConnection.addEventListener (NetStatusEvent.NET_STATUS, netConnection_onNetStatus);
		#else
		netStream.play ("assets/example.mp4");
		#end */

		var bitmap = new Bitmap (Assets.getBitmapData ("assets/openfl.png"));
		addChild (bitmap);
		
		bitmap.x = (stage.stageWidth - bitmap.width) / 2;
		bitmap.y = (stage.stageHeight - bitmap.height) / 2;
	}
	
/* 	
	private function client_onMetaData (metaData:Dynamic) {
		
		video.attachNetStream (netStream);
		
		video.width = video.videoWidth;
		video.height = video.videoHeight;
		
	}
	
	
	private function netStream_onAsyncError (event:AsyncErrorEvent):Void {
		
		trace ("Error loading video");
		
	}
	
	
	private function netConnection_onNetStatus (event:NetStatusEvent):Void {
		
		if (event.info.code == "NetStream.Play.Complete") {
			
			Actuate.tween (overlay, 1, { alpha: 1 });
			
		}
		
	}
	
	
	private function overlay_onMouseDown (event:MouseEvent):Void {
		
		Actuate.tween (overlay, 2, { alpha: 0 });
		netStream.play ("assets/example.mp4");
		
	} */
	
	
}