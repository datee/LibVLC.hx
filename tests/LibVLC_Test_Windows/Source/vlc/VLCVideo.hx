package vlc;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.events.Event;
#if cpp

import cpp.Char;
import cpp.ConstStar;
import cpp.Function;
import cpp.Native;
import cpp.Star;
import haxe.io.Bytes;
import vlc.LibVLC;

using cpp.NativeString;

@:headerInclude('vlc/vlc.h')
@:cppNamespaceCode('

// Static callbacks ///////////////////////////////////////////////////////////////////////

#ifndef VLCVideoCallbacks
#define VLCVideoCallbacks

void *VLCVideo_lockStatic(void *data, void **p_pixels)
{
	if (((VLCVideo_obj *)data)->canDraw)
		*p_pixels=&((VLCVideo_obj *)data)->pixels[0];
	return NULL;
}

void VLCVideo_unlockStatic(void *data, void *id, void *const *p_pixels)
{
}

void VLCVideo_displayStatic(void *data, void *picture)
{
}

unsigned VLCVideo_setupStatic(void** data, char* chroma, unsigned* width, unsigned* height, unsigned* pitches, unsigned* lines)
{
	((VLCVideo_obj *)*data)->cb_setup_active=true;

 	unsigned _w = (*width);
	unsigned _h = (*height);
	unsigned _pitch = _w*4;
	unsigned _frame = _w*_h*4;
	(*pitches) = _pitch;
	(*lines) = _h;
	memcpy(chroma, "RV32", 4);

	((VLCVideo_obj *)*data)->videoWidth=_w;
	((VLCVideo_obj *)*data)->videoHeight=_h;
	return 1;
}

void VLCVideo_cleanupStatic(void *data)
{
	((VLCVideo_obj *)data)->cb_cleanup_active=true;	
}

#endif

')
@:keep
// @:unreflective
@:buildXml('<include name="../../../Source/vlc/build/VLCBuild.xml" />')
class VLCVideo extends openfl.display.Bitmap
{
	///////////////////////////////////////////////////////////////////////////////////////////
	
	var cb_cleanup_active					: Bool					= false;
	var cb_setup_active						: Bool					= false;

	static public var vlcInstance			: LibVLC_Instance_p;
	public var mediaPlayer					: LibVLC_MediaPlayer_p;
	public var media						: LibVLC_Media_p;
	public var audioOutList					: LibVLC_AudioOutput_p;
	public var eventManager					: LibVLC_Eventmanager_p;

	public var pixels						: Array<cpp.UInt8>;
	// public var texture						: kha.Image;
	public var canDraw						: Bool					= false;
	public var videoWidth					: Int					= 0;
	public var videoHeight					: Int					= 0;
	public var durationInMs					: Int					= 0;
	public var durationInSec				: Float					= 0;
	public var currentTimeInMS				: Int					= 0;
	public var currentProgress				: Float					= 0;
	// public var isPlaying(get,never)			: Bool					= 0;
	// public var mediaCurrentPosition(get,never): Float					= 0;
	public var source	 					: String;
	public var endReached 					: Bool					= false;
	public var isPlaying					: Bool					= false;
	public var isPaused						: Bool					= false;
	public var isDisposed					: Bool					= false;
	public var looping						: Bool					= false;
	
	public var isStopped					: Bool					= false;
	var frameRect							: Rectangle;
	// public var vlcMutex			: Mutex2;

	///////////////////////////////////////////////////////////////////////////////////////////

	// public var onOpening					: (VLCVideo)->Void;
	public var onReady						: (VLCVideo)->Void;
	public var onPlaying					: (VLCVideo)->Void;
	public var onStopped					: (VLCVideo)->Void;
	public var onPaused						: (VLCVideo)->Void;
	public var onResume						: (VLCVideo)->Void;
	// public var onProgress					: (VLCVideo)->Void;
	public var onComplete					: (VLCVideo)->Void;
	public var onDisposed					: (VLCVideo)->Void;

	///////////////////////////////////////////////////////////////////////////////////////////

	public function new(?source:String)
	{
		super();
		if (vlcInstance==null)
			vlcInstance = LibVLC.New(0, null);
		/*{
			untyped __cpp__('
			
			char const *vlc_argv[] = {

				"--no-audio", // Dont play audio.
				"--no-xlib", // Dont use Xlib.

				// Apply a video filter.
				//"--video-filter", "sepia",
				//"--sepia-intensity=200"
			};
			int vlc_argc = sizeof(vlc_argv) / sizeof(*vlc_argv);			
			
			
			');

			vlcInstance = untyped __cpp__('libvlc_new(vlc_argc, vlc_argv)');

		}
		*/
		// audioOutList = LibVLC.getAudioOutputList(vlcInstance);
		
		// setUniqueFullscreenMode(uniqueFullscreenMode);

		this.source = source;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	function onAddedToStage(e:Event) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.ENTER_FRAME, update);
		var p = source;
		source=null;
		playVideo(p);
	}

	public function update(e:Event)
	{
		if (cb_setup_active)
			setupFormat();
		if (cb_cleanup_active)
			cleanupFormat();
	
		if (mediaPlayer!=null)
		{
			var wasPlaying = isPlaying;
			if (!isStopped)
			{
				isPlaying = LibVLC.mediaPlayerIsPlaying(mediaPlayer);
				currentTimeInMS = LibVLC.mediaPlayerGetTime(mediaPlayer);

				if (durationInMs>0)
					currentProgress = currentTimeInMS/durationInMs;
				else
					currentProgress = 0;

				var oldEndWasReached = endReached;
				endReached = currentProgress>=1;

				if (endReached && !oldEndWasReached)
					if (onComplete!=null)
						onComplete(this);				
			}
			else
				isPlaying = false;


			if (!wasPlaying && isPlaying)
				if (onPlaying!=null)
					onPlaying(this);
			else if (wasPlaying && !isPlaying)
				if (onStopped!=null)
					onStopped(this);
		}

		grabFrame();
	}

	// public function draw(g2:kha.graphics2.Graphics, ?x:Null<Float>, ?y:Null<Float>, ?w:Null<Float>, ?h:Null<Float>)
	// {
	// 	if (isDisposed)
	// 		return;
			
	// 	if (needsUpdate)
	// 		update();

	// 	needsUpdate = true;

	// 	if (!canDraw)
	// 		return;

	// 	grabFrame();

	// 	@:privateAccess g2.setPipeline(pipeline);
	// 	g2.drawScaledSubImage(texture, 0, 0, texture.width, texture.height, x, y, w, h);
	// 	@:privateAccess g2.setPipeline(null);
	// }

	function grabFrame()
	{
		if (!canDraw)
			return;

		if (pixels != null)
		{
			// this.bitmapData.setPixels( frameRect, Bytes.ofData(pixels) );

			// Warning! Custom buffer copy - VLC buffer directly to Lime

			var data = this.bitmapData.image.buffer.data;
			var stride = this.bitmapData.image.buffer.stride;
			var ss:Int=4;
			var ww:Int = Std.int(width);
			for (yy in 0...Std.int(height))
			{
				for (xx in 0...Std.int(width))
				{
					data[yy * stride + xx * ss + 0] = pixels[(yy * ww + xx) * ss + 0];
					data[yy * stride + xx * ss + 1] = pixels[(yy * ww + xx) * ss + 1];
					data[yy * stride + xx * ss + 2] = pixels[(yy * ww + xx) * ss + 2];
					data[yy * stride + xx * ss + 3] = 255;
				}
			}

			this.bitmapData.image.dirty = true;
			this.bitmapData.image.version++;
		}		
	}

	// Setup functions ////////////////////////////////////////////////////////////////////////

	function setupFormat()
	{
		cb_setup_active = false;
		pixels.resize(videoWidth*videoHeight*4);
 		this.bitmapData = new BitmapData(Std.int(videoWidth), Std.int(videoHeight), true, 0);
		frameRect = new Rectangle(0, 0, Std.int(videoWidth), Std.int(videoHeight));
		width = videoWidth;
		height = videoHeight;
		canDraw = true;
		if (onReady!=null)
			onReady(this); 
	}

	function cleanupFormat()
	{
		cb_cleanup_active = false;
	}

	///////////////////////////////////////////////////////////////////////////////////////////

	public function setSource(path:String)
	{
		source = processPath(path);
		media = LibVLC.mediaNewPath(vlcInstance,source);		
		mediaPlayer = LibVLC.mediaPlayerNewFromMedia(media);
		
		LibVLC.mediaParse(media);
		//LibVLC.mediaParseWithOptions(media,untyped __cpp__('libvlc_media_parse_local'),0);

		if (looping)
			LibVLC.mediaAddOption(media, "input-repeat=-1" );
		else
			LibVLC.mediaAddOption(media, "input-repeat=0" );

		durationInMs = LibVLC.mediaPlayerGetDuration(media);
		durationInSec = (durationInMs*0.001);

		LibVLC.mediaRelease(media);
		
		LibVLC.setAudioOutput(mediaPlayer,"waveout");
		LibVLC.audioSetVolume(mediaPlayer, 10);

		// Pixelbuffer
		if (pixels==null)
			pixels = [];

		//pixels.resize(2000*2000*4);

		LibVLC.setFormatCallbacks(mediaPlayer, getSetupStaticCB(), getCleanupStaticCB());		
		LibVLC.setCallbacks(mediaPlayer, getLockStaticCB(), getUnlockStaticCB(), getDisplayStaticCB(), getThisPointer());	
//libvlc_video_set_format(mp, "RGBA", VIDEOWIDTH, VIDEOHEIGHT, VIDEOWIDTH * 4);
		// eventManager = LibVLC.setEventmanager(mediaPlayer);	
		// setupEvents(eventManager);
	}	
	
	// External functions /////////////////////////////////////////////////////////////////////

	public function playVideo(path:String, loop:Bool=false)	 
	{
		if (path==null)
			return;

		this.looping = loop;

		if (source!=path)
		{
			source = path;
			playInternal();
		}
	}

	public function play(loop: Bool = false) : Void	 
	{
		if (isPaused)
			resume();
		else
		{
			this.looping = loop;
			playInternal();
		}
	}

	/**
	 * Pause the media element.
	 */
	public function pause()
	{
		if (mediaPlayer!=null)
			LibVLC.mediaPlayerSetPause(mediaPlayer,1);
		isPaused = true;
	}
	
	/**
	 * Resume the media element from pause.
	 */
	public function resume()
	{
		if (mediaPlayer!=null)
			LibVLC.mediaPlayerSetPause(mediaPlayer,0);
		isPaused = false;		
	}
	
	/**
	 * Pause the stop element.
	 */
	public function stop()
	{
		stopInternal();
	}

	public function seek(newTimeInMS:Int)
	{
		if (mediaPlayer!=null)
		{
			LibVLC.mediaPlayerSetTime(mediaPlayer,newTimeInMS);
		}
	}

	/**
	 * Return the media length, in milliseconds.
	 */
	public function getLength():Int // Milliseconds
	{ 
		return durationInMs;
	}
	
	private function get_position():Int
	{
		return currentTimeInMS;
	}

	private function set_position(value:Int): Int
	{
		seek(value);
		return value;
	}

	/**
	 * If the media has finished or not.
	 */
	public function isFinished():Bool
	{
		return endReached;
	}

	/**	
	 * Return the media volume, between 0 and 1.
	 */
	public function getVolume():Float
	{
		if (mediaPlayer!=null)
			return LibVLC.audioGetVolume(mediaPlayer)*0.001;
		else
			return 0;
	}

	/**
	 * Set the media volume, between 0 and 1.
	 *
	 * @param volume	The new volume, between 0 and 1.
	 */
	public function setVolume(volume:Float)
	{ 
		if (mediaPlayer!=null)
			LibVLC.audioSetVolume(mediaPlayer,Std.int(volume*1000));
	}	

	/**
	 * The width of the video file in pixels.
	 */
	// public function width(): Int
	// {
	// 	return videoWidth;
	// }
	
	/**
	 * The height of the video file in pixels.
	 */
	// public function height(): Int
	// {
	// 	return videoHeight;
	// }	

	// Internal functions /////////////////////////////////////////////////////////////////////

	function playInternal()
	{
		setSource(source);
		if (mediaPlayer!=null)
		{
			isStopped = false;
			LibVLC.mediaPlayerPlay(mediaPlayer);
		}
	}

	function stopInternal()
	{
		if (mediaPlayer!=null && !isStopped)
		{
			isStopped = true;
			LibVLC.mediaPlayerStop(mediaPlayer);
			LibVLC.mediaPlayerRelease(mediaPlayer);
		}
	}

	function processPath(p:String):String
	{
		p = p.split("/").join("\\");
		return p;
	}

	// Dispose ////////////////////////////////////////////////////////////////////////////////

	public function dispose()
	{
		isDisposed=true;
		canDraw=false;

		stop();
		// detachEvents(eventManager);

		// onOpening = null;
		onReady = null;
		onPlaying = null;
		onStopped = null;
		onPaused = null;
		onResume = null;
		// onProgress = null;
		onComplete = null;
		onDisposed = null;

		// if (texture!=null)
		// {
		// 	texture.unload();
		// 	texture = null;
		// }
		pixels = null;

		eventManager = null;
		audioOutList = null;
		media = null;
		mediaPlayer = null;
		
		// clearInternalQueue();
		// deleteInternalQueue();

		if (onDisposed!=null)
			onDisposed(this);				

		//LibVLC.release(vlcInstance); //? Keep it?
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////

	// Raw c++ interface //////////////////////////////////////////////////////////////////////

	// @:functionCode("return tx->texture->lock();")
	// function lockTexture(tx:kha.Image):LibVLC_PixelBuffer_p { return null; }

	// @:functionCode("tx->texture->unlock();")
	// function unlockTexture(tx:kha.Image) { }

	// @:functionCode("return tx->texture->width;")
	// function getTextureWidth(tx:kha.Image):UInt { return 0; }

	// @:functionCode("return tx->texture->height;")
	// function getTextureHeight(tx:kha.Image):UInt { return 0; }

	@:functionCode("return &pixels[0];")
	function getPixelBuffer():LibVLC_PixelBuffer_p { return null; }

	@:functionCode("return VLCVideo_setupStatic;")
	function getSetupStaticCB():LibVLC_Video_Format_CB { return null; }

	@:functionCode("return VLCVideo_cleanupStatic;")
	function getCleanupStaticCB():LibVLC_Video_Cleanup_CB { return null; }

	@:functionCode("return VLCVideo_lockStatic;")
	function getLockStaticCB():LibVLC_Video_Lock_CB { return null; }

	@:functionCode("return VLCVideo_unlockStatic;")
	function getUnlockStaticCB():LibVLC_Video_Unlock_CB { return null; }

	@:functionCode("return VLCVideo_displayStatic;")
	function getDisplayStaticCB():LibVLC_Video_Display_CB { return null; }

	// @:functionCode("return VLCVideo_eventStatic;")
	// function getEventStaticCB():LibVLC_Callback { return null; }

	@:functionCode("return this;")
	function getThisPointer():cpp.Star<cpp.Void> { return null; }

	// @:functionCode("if (!internalEvent.empty()) return internalEvent.back(); else return NULL;")
	// function getLastInternalEventQueueItem():LibVLC_Event { return null; }

	// @:functionCode("return internalEvent[0];") @:void
	// function getOldestItemFromInternalQueue():LibVLC_Event { return null; }

/* 	@:functionCode("internalEvent.erase(internalEvent.begin());")
	function eraseOldestItemFromInternalQueue() { }
	
	@:functionCode("internalEvent.clear();")
	function clearInternalQueue() { }
	
	@:functionCode("internalEvent.resize(0);")
	function deleteInternalQueue() { }

	@:functionCode("return internalEvent.empty();")
	function isInternalQueueEmpty():Bool { return true; } */

	///////////////////////////////////////////////////////////////////////////////////////////
}

#end
