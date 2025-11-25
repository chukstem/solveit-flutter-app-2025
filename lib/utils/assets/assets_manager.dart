// Asset paths
const String baseSvgPath = 'assets/svgs/';
const String basePngPath = 'assets/images/';
const String baseMapStylePath = 'assets/maps/';
const String baseMusicPath = 'assets/music/';

// App Icons
final String appIcon = 'launcher_icon'.png;
final String onboarding = 'onboarding'.png;
final String onboarding1 = 'onboarding_1'.png;
final String solveitText = 'solveit_text'.png;
final String onboarding2 = 'onboarding_2'.png;
final String onboarding3 = 'onboarding_3'.png;
final String onboarding4 = 'onboarding_4'.png;
final String solveitLogo = 'launcher_icon'.png;
final String choosePassport = 'passport'.png;

// SVG Icons
final String ratingHalfEmptySvg = 'rating_half'.svg;
final String ratingEmptySvg = 'rating_empty'.svg;
final String ratingStarSvg = 'rating_star'.svg;
final String successCheckSvg = 'success_icon'.svg;
final String eyeClosedSvg = 'eye_close'.svg;
final String dateOfBirthSvg = 'date_of_birth'.svg;
final String studentIconSvg = 'student_icon'.svg;
final String schoolStaffSvg = 'school_staff'.svg;
final String otherUserSvg = 'other_user'.svg;
final String lecturerIconSvg = 'lecturer_icon'.svg;
final String googleSvg = 'google_icon'.svg;
final String facebookSvg = 'facebook_icon'.svg;
final String notificationSvg = 'notification'.svg;
final String bnHome = 'home'.svg;
final String bnMarketplace = 'market_place'.svg;
final String bnServices = 'services'.svg;
final String bnForums = 'forums'.svg;
final String appleSvg = 'apple_icon'.svg;
final String nigerianFlag = 'nigeria_flag'.svg;
final String networkIcon = 'network'.svg;
final String messageIcon = 'message_icon'.svg;
final String headPhone = 'headphone'.svg;
final String messageQuote = 'message_quote'.svg;
final String searchIcon = 'search'.svg;
final String checkIcon = 'check'.svg;
final String doubleCheckIcon = 'double_check'.svg;
final String archiveIcon = 'archive'.svg;
final String heartIcon = 'heart'.svg;
final String shareIcon = 'share'.svg;
final String onboardingArrowSvg = 'on_arrow'.svg;
final String closeIconSvg = 'close'.svg;
final String addSvg = 'add'.svg;
final String searchCircleSvg = 'search_circle'.svg;
final String filterSvg = 'filter'.svg;
final String marketPlaceText = 'market_place_text'.svg;
final String marketPlaceBold = 'market_place_bold'.svg;
final String editSvg = 'edit'.svg;
final String commentFilledSvg = 'comment_filled'.svg;
final String commentPlainSvg = 'comment_plain'.svg;
final String thumbsUpFilledSvg = 'thumbs_up_filled'.svg;
final String thumbsUpPlainSvg = 'thumbs_up_plain'.svg;

final String addAttachmentSvg = 'attachment'.svg;
final String sendMessageFilledSvg = 'send_message_filled'.svg;
final String sendMessagePlainSvg = 'send_message_plain'.svg;
final String recordVNSvg = 'mic'.svg;

final String sendAudioSvg = 'send_audio'.svg;
final String playAudioSvg = 'play_audio'.svg;
final String pauseAudioSvg = 'pause'.svg;
final String deleteAudioSvg = 'delete'.svg;
final String newMessageSvg = 'new_message'.svg;

final String moreSvg = 'more'.svg;
final String verifiedSvg = 'verified'.svg;
final String replyPhoto = 'reply_photo'.svg;
final String documentSvg = 'document'.svg;
final String forumsTextSvg = 'forums_text'.svg;
final String servicesTextSvg = 'services_text'.svg;
final String bagButtonSvg = 'bag_button'.svg;
final String playConsoleSvg = 'play_console'.svg;

final String audioCallSvg = 'audio_call'.svg;
final String cancelCallSvg = 'cancel_call'.svg;
final String videoBoarderSvg = 'video_boarder'.svg;
final String callAgainSvg = 'call_again'.svg;
final String videoCallSvg = 'video_call'.svg;
final String muteSvg = 'mute'.svg;
final String pictureInPictureSvg = 'picture_in_picture'.svg;
final String endCallSvg = 'end_call'.svg;
final String speakerFilledSvg = 'speaker_filled'.svg;

// Extensions
extension ImageExtension on String {
  // PNG paths
  String get png => '$basePngPath$this.png';
  // SVG paths
  String get svg => '$baseSvgPath$this.svg';
  // Music paths
  String music(String format) => '$baseMusicPath$this.$format';
  // Map styles
  String get txt => '$baseMapStylePath$this.txt';
}
