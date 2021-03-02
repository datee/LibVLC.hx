package vlc;

extern class LibVLC
{
	// Externs /////////////////////////////////////////////////////////////////////////

	/*
	* Create and initialize a libvlc instance. 
	*/
	@:native("libvlc_new")
	extern public static function New(argc:Int, argv:ConstCharStarConstStar):LibVLC_Instance_p;

	/*
	* Create a media for a certain file path.
	*/
	@:native("libvlc_media_new_path")
	extern public static function mediaNewPath(p_instance:LibVLC_Instance_p, path:String):LibVLC_Media_p;

	/*
	* Create a Media Player object from a Media.
	*/
	@:native("libvlc_media_player_new_from_media")
	extern public static function mediaPlayerNewFromMedia(p_md:LibVLC_Media_p):LibVLC_MediaPlayer_p;

	/*
	* ...
	*/
	@:native("libvlc_audio_output_list_get")
	extern public static function getAudioOutputList(vlcInst:LibVLC_Instance_p):LibVLC_AudioOutput_p;

	/*
	* ...
	*/
	@:native("libvlc_audio_output_set")
	extern public static function setAudioOutput(p_mi:LibVLC_MediaPlayer_p,deviceName:String):Void;
	
	/*
	* Play
	*/
	@:native("libvlc_media_player_play")
	extern public static function mediaPlayerPlay(p_mi:LibVLC_MediaPlayer_p):Void;
 	
	/*
	* Stop
	*/
	@:native("libvlc_media_player_stop")
	extern public static function mediaPlayerStop(p_mi:LibVLC_MediaPlayer_p):Void;
 	
 	
	/*
	* Pause or resume (no effect if there is no media)
	*
	* Parameters
	* mp	the Media Player
	* do_pause	play/resume if zero, pause if non-zero
	*/
	@:native("libvlc_media_player_set_pause")
	extern public static function mediaPlayerSetPause(p_mi:LibVLC_MediaPlayer_p, do_pause:Int):Void;
 	
	/*
	* IsPlaying
	*/
	@:native("libvlc_media_player_is_playing")
	extern public static function mediaPlayerIsPlaying(p_mi:LibVLC_MediaPlayer_p):Bool;
 	
	/*
	* Release a media_player after use Decrement the reference count of a media player object.
	*/
	@:native("libvlc_media_player_release")
	extern public static function mediaPlayerRelease(p_mi:LibVLC_MediaPlayer_p):Void;
 	
	/*
	* Decrement the reference count of a libvlc instance, and destroy it if it reaches zero.
	*/
	@:native("libvlc_release")
	extern public static function release(p_instance:LibVLC_Instance_p):Void;

	/*
	* Increments the reference count of a libvlc instance.
	*/
	@:native("libvlc_retain")
	extern public static function retain(p_instance:LibVLC_Instance_p):Void;

	/*
	* Get current software audio volume.
	*/
	@:native("libvlc_audio_get_volume")
	extern public static function audioGetVolume(p_mi:LibVLC_MediaPlayer_p):Int;
 	
	/*
	* Set current software audio volume.
	*/
	@:native("libvlc_audio_set_volume")
	extern public static function audioSetVolume(p_mi:LibVLC_MediaPlayer_p,i_volume:Int):Int;
 	
	/*
	* Decrement the reference count of a media descriptor object.
	*/
	@:native("libvlc_media_release")
	extern public static function mediaRelease(p_md:LibVLC_Media_p):Void;
 	
	/*
	* Parse flags used by libvlc_media_parse_with_options()
	*/
	@:native("libvlc_media_parse")
	extern public static function mediaParse(p_md:LibVLC_Media_p):Void;

	/*
	*/
	@:native("libvlc_media_parse_with_options")
	extern public static function mediaParseWithOptions(p_md:LibVLC_Media_p,parse_flag:LibVLC_MediaParseFlag,timeout:Int):Int;

	/*
	* Set decoded video chroma and dimensions.
	* libvlc_video_set_format_callbacks (libvlc_media_player_t *mp, libvlc_video_format_cb setup, libvlc_video_cleanup_cb cleanup)
	*/
	@:native("libvlc_video_set_format_callbacks")
	extern public static function setFormatCallbacks(mp:LibVLC_MediaPlayer_p,setup:LibVLC_Video_Format_CB,cleanup:LibVLC_Video_Cleanup_CB):Void;
	 	
	/*
	* Set callbacks and private data to render decoded video to a custom area in memory.
	* libvlc_video_set_callbacks (libvlc_media_player_t *mp, libvlc_video_lock_cb lock, libvlc_video_unlock_cb unlock, libvlc_video_display_cb display, void *opaque)
	*/
	@:native("libvlc_video_set_callbacks") 
	extern public static function setCallbacks(mp:LibVLC_MediaPlayer_p,lock:LibVLC_Video_Lock_CB,unlock:LibVLC_Video_Unlock_CB,display:LibVLC_Video_Display_CB, opaque:VoidStar):Void;

	/*
	* Get the Event Manager from which the media player send event.
	* LIBVLC_API libvlc_event_manager_t* libvlc_media_player_event_manager	(libvlc_media_player_t*	p_mi)	
	*/
	@:native("libvlc_media_player_event_manager")
	extern public static function setEventmanager(mp:LibVLC_MediaPlayer_p):LibVLC_Eventmanager_p;

	/*
	* Register for an event notification
	*/
	@:native("libvlc_event_attach")
	extern public static function eventAttach(p_event_manager:LibVLC_Eventmanager_p,i_event_type:LibVLC_EventType,f_callback:LibVLC_Callback,user_data:VoidStar):Int;

	/*
	* UnRegister for an event notification
	*/
	@:native("libvlc_event_detach")
	extern public static function eventDetach(p_event_manager:LibVLC_Eventmanager_p,i_event_type:LibVLC_EventType,f_callback:LibVLC_Callback,user_data:VoidStar):Int;

	/*
	* Registers a callback for the LibVLC exit event
	*/
	@:native("libvlc_set_exit_handler")
	extern public static function setExitHandler(p_instance:LibVLC_Instance_p,cb:VoidStar,opaque:VoidStar):Void;

	/*
	* Get duration (in ms) of media descriptor object item.
	* 
	* Note, you need to call libvlc_media_parse_with_options() or play the media at least once before calling this function. Not doing this will result in an undefined result.
	* See also
	* libvlc_media_parse_with_options
	* Parameters
	* p_md	media descriptor object
	* Returns
	* duration of media item or -1 on error
	* 
	*/
	@:native("libvlc_media_get_duration")
	extern public static function mediaPlayerGetDuration(p_md:LibVLC_Media_p):LibVLC_Time_t;

	/*
	* Get the current movie time (in ms).
	*/
	@:native("libvlc_media_player_get_time")
	extern public static function mediaPlayerGetTime(p_mi:LibVLC_MediaPlayer_p):LibVLC_Time_t;

	/**
	* Set the movie time (in ms). This has no effect if no media is being played. Not all formats and protocols support this.
	*
	* Parameters
	* p_mi	the Media Player
	* b_fast	prefer fast seeking or precise seeking
	* i_time	the movie time (in ms).
	* Returns
	* 0 on success, -1 on error
	*/
	@:native("libvlc_media_player_set_time")
	extern public static function mediaPlayerSetTime(p_mi:LibVLC_MediaPlayer_p,i_time:LibVLC_Time_t):Int;
	// extern public static function mediaPlayerSetTime(p_mi:LibVLC_MediaPlayer_p,i_time:LibVLC_Time_t,b_fast:Bool):Int;

	/**
	* Get the pixel dimensions of a video.
	*
	* \param p_mi media player
	* \param num number of the video (starting from, and most commonly 0)
	* \param px pointer to get the pixel width [OUT]
	* \param py pointer to get the pixel height [OUT]
	* \return 0 on success, -1 if the specified video does not exist
	*/
	@:native("libvlc_video_get_size")
	extern public static function videoGetSize(p_mi:LibVLC_MediaPlayer_p, num:UInt,width:UnsignedStar, height:UnsignedStar ):Int;

	/**
	* Add an option to the media.
	*
	* This option will be used to determine how the media_player will read the media. This allows to use VLC's advanced reading/streaming options on a per-media basis.
	* 
	* Note
	* The options are listed in 'vlc –longhelp' from the command line, e.g. "--sout-all". Keep in mind that available options and their semantics vary across LibVLC versions and builds.
	* Warning
	* Not all options affects libvlc_media_t objects: Specifically, due to architectural issues most audio and video options, such as text renderer options, have no effects on an individual media. These options must be set through libvlc_new() instead.
	* arameters
	* p_md	the media descriptor
	* psz_options	the options (as a string)
	*/
	@:native("libvlc_media_add_option")
	extern public static function mediaAddOption(p_md:LibVLC_Media_p, psz_options:String):Void;

}

typedef LibVLC_Instance_p 						= cpp.Star<LibVLC_Instance>;
typedef LibVLC_AudioOutput_p 					= cpp.Star<LibVLC_AudioOutput>;
typedef LibVLC_MediaPlayer_p 					= cpp.Star<LibVLC_MediaPlayer>;
typedef LibVLC_Media_p 							= cpp.Star<LibVLC_Media>;
typedef LibVLC_Eventmanager_p 					= cpp.Star<LibVLC_Eventmanager>;
typedef LibVLC_Event_p		 					= cpp.Star<LibVLC_Event>;
typedef LibVLC_Event_const_p 					= cpp.ConstStar<LibVLC_Event>;
typedef LibVLC_Time_t		 					= cpp.Int64;

@:native("libvlc_audio_output_t") 				extern class LibVLC_AudioOutput {}
@:native("libvlc_instance_t") 					extern class LibVLC_Instance {}
@:native("libvlc_media_player_t") 				extern class LibVLC_MediaPlayer {}
@:native("libvlc_media_t") 						extern class LibVLC_Media {}
@:native("libvlc_event_manager_t")				extern class LibVLC_Eventmanager {}
@:native("libvlc_media_parse_flag_t")			extern class LibVLC_MediaParseFlag {}


typedef LibVLC_PixelBuffer_p = cpp.Star<LibVLC_PixelBuffer_t>;
typedef LibVLC_PixelBuffer_t = cpp.UInt8;
// @:native("unsigned char")									extern class LibVLC_PixelBuffer {}

typedef LibVLC_Video_Format_CB = cpp.Callable<(opaque:VoidStarStar, chroma:CharStar,width:UnsignedStar, height:UnsignedStar, pitches:UnsignedStar, lines:UnsignedStar) -> Unsigned>;
typedef LibVLC_Video_Cleanup_CB = cpp.Callable<(opaque:VoidStar) -> Void>;
typedef LibVLC_Video_Lock_CB = cpp.Callable<(data : VoidStar, p_pixels : VoidStarStar) -> VoidStar>;
typedef LibVLC_Video_Unlock_CB = cpp.Callable<(data:VoidStar, id:VoidStar, p_pixels:VoidStarConstStar) -> Void>;
typedef LibVLC_Video_Display_CB = cpp.Callable<(opaque : VoidStar, picture : VoidStar) -> Void>;
typedef LibVLC_Callback = cpp.Callable<(p_event:cpp.ConstStar<LibVLC_Event>,p_data:VoidStar) -> Void>;
typedef CharStar = cpp.Star<cpp.Char>;
typedef UnsignedCharStar = cpp.Star<cpp.UInt8>;
typedef UnsignedStar = cpp.Star<cpp.UInt32>;
typedef Unsigned = cpp.UInt32;
typedef VoidStar = cpp.Star<cpp.Void>;
typedef VoidStarStar = cpp.Star<cpp.Star<cpp.Void>>;
// typedef VoidStarConstStar = cpp.Star<cpp.Star<cpp.Void>>;
@:native("void *const *") 	extern class VoidStarConstStar {}


@:native("libvlc_event_t") 
@:structAccess
extern class LibVLC_Event
{
	public var type			: LibVLC_EventType;	
	public var u			: LibVLC_Event_U;	
}

@:native("std::mutex") 
@:structAccess
extern class Mutex
{
	public function lock() : Void;		
	public function unlock() : Void;		
}

@:native("const char *const *") 
extern class ConstCharStarConstStar
{
}

@:native("libvlc_event_t::u") 
@:structAccess
extern class LibVLC_Event_U
{
	public var media_player_position_changed	: LIBVLC_MediaPlayer_PositionChanged;	
	public var media_player_time_changed		: LIBVLC_MediaPlayer_TimeChanged;	
	public var media_player_length_changed		: LIBVLC_MediaPlayer_LengthChanged;	
	public var media_player_buffering			: LIBVLC_MediaPlayer_Buffering;	
	public var media_player_seekable_changed	: LIBVLC_MediaPlayer_SeekableChanged;	
	public var media_player_pausable_changed	: LIBVLC_MediaPlayer_PausableChanged;	
}

@:native("media_player_position_changed") 
@:structAccess
extern class LIBVLC_MediaPlayer_PositionChanged
{
	public var new_position		: Float;		
}

@:native("media_player_time_changed") 
@:structAccess
extern class LIBVLC_MediaPlayer_TimeChanged
{
	public var new_time			: cpp.Int64;		
}

@:native("media_player_length_changed") 
@:structAccess
extern class LIBVLC_MediaPlayer_LengthChanged
{
	public var new_length			: cpp.Int64;		
}

@:native("media_player_buffering") 
@:structAccess
extern class LIBVLC_MediaPlayer_Buffering
{
	public var new_cache 			: Float;		
}

@:native("media_player_seekable_changed") 
@:structAccess
extern class LIBVLC_MediaPlayer_SeekableChanged
{
	public var new_seekable 			: Bool;		
}

@:native("media_player_pausable_changed") 
@:structAccess
extern class LIBVLC_MediaPlayer_PausableChanged
{
	public var new_pausable 			: Bool;		
}

// @:native("libvlc_event_type_t") 
enum abstract LibVLC_EventType(Int) from Int to Int
{
	var mediaMetaChanged				= 0;
	var mediaSubItemAdded				= 1;
	var mediaDurationChanged			= 2;
	var mediaParsedChanged				= 3;
	var mediaFreed						= 4;
	var mediaStateChanged				= 5;
	var mediaSubItemTreeAdded			= 6;

	var mediaPlayerMediaChanged			= 256;
	var mediaPlayerNothingSpecial		= 257;
	var mediaPlayerOpening				= 258;
	var mediaPlayerBuffering			= 259;
	var mediaPlayerPlaying				= 260;
	var mediaPlayerPaused				= 261;
	var mediaPlayerStopped				= 262;
	var mediaPlayerForward				= 263;
	var mediaPlayerBackward				= 264;
	var mediaPlayerEndReached			= 265;
	var mediaPlayerEncounteredError		= 266;
	var mediaPlayerTimeChanged			= 267;
	var mediaPlayerPositionChanged		= 268;
	var mediaPlayerSeekableChange		= 269;
	var mediaPlayerPausableChanged		= 270;
	var mediaPlayerTitleChanged			= 271;
	var mediaPlayerSnapshotTaken		= 272;
	var mediaPlayerLengthChanged		= 273;
	var mediaPlayerVout					= 274;
	var mediaPlayerScrambledChanged		= 275;
	var mediaPlayerCorked				= 279;
	var mediaPlayerUncorked				= 280;
	var mediaPlayerMuted				= 281;
	var mediaPlayerUnmuted				= 282;
	var mediaPlayerAudioVolume			= 283;

	var mediaListItemAdded				= 512;
	var mediaListWillAddItem			= 513;
	var mediaListItemDeleted			= 514;
	var mediaListWillDeleteItem			= 515;

	var mediaListViewItemAdded			= 768;
	var mediaListViewWillAddItem		= 769;
	var mediaListViewItemDeleted		= 770;
	var mediaListViewWillDeleteItem		= 771;

	var mediaListPlayerPlayed			= 1024;
	var mediaListPlayerNextItemSet		= 1025;
	var mediaListPlayerStopped			= 1026;

	var vlmMediaAdded					= 1536;
	var vlmMediaRemoved					= 1537;
	var vlmMediaChanged					= 1538;
	var vlmMediaInstanceStarted			= 1539;
	var vlmMediaInstanceStopped			= 1540;
	var vlmMediaInstanceStatusInit		= 1541;
	var vlmMediaInstanceStatusOpening	= 1542;
	var vlmMediaInstanceStatusPlaying	= 1543;
	var vlmMediaInstanceStatusPause		= 1544;
	var vlmMediaInstanceStatusEnd		= 1545;
	var vlmMediaInstanceStatusError		= 1546;


}
