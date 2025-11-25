# View Models Guide

This document explains the core view models used throughout the SolveitApp for handling user inputs, media, and audio.

## InputfieldViewModel

`InputfieldViewModel` manages reply functionality across posts, forums, and messages.

**Key Properties:**
- `replyingTo`: An object containing information about the comment/message being replied to.

**Key Methods:**
- `setReply(ReplyingTo? comment)`: Sets the current reply target.
- `clearReply()`: Clears the current reply target.

**Usage Example:**
```dart
// To set a reply
context.read<InputfieldViewmodel>().setReply(
  ReplyingTo(
    comment: "Original message text",
    name: "User Name",
    type: ["image_url.jpg"], // Media attached to original message
  )
);

// To clear a reply
context.read<InputfieldViewmodel>().clearReply();
```

## AudioPlaybackManager

`AudioPlaybackManager` handles audio playback across the app, ensuring only one audio file plays at a time.

**Key Properties:**
- `currentlyPlayingPath`: Path of the currently playing audio file.

**Key Methods:**
- `play(PlayerController controller, String path)`: Plays an audio file and stops any currently playing audio.
- `stop()`: Stops the currently playing audio.
- `isPlaying(String path)`: Checks if a specific audio file is currently playing.

**Usage Example:**
```dart
// To play an audio
context.read<AudioPlaybackManager>().play(playerController, audioPath);

// To stop playback
context.read<AudioPlaybackManager>().stop();

// To check if an audio is playing
bool isPlaying = context.read<AudioPlaybackManager>().isPlaying(audioPath);
```

## MediaPreviewViewModel

`MediaPreviewViewModel` manages media attachments (images, videos, files) for posts, messages, and forum chats.

**Key Properties:**
- `selectedMedia`: List of paths to selected media files.
- `caption`: Text caption associated with the media.
- `postType`: Enum indicating the context (forum, chat, or post).

**Key Methods:**
- `addMedia(List<String> files)`: Adds media files to the preview.
- `removeMedia(int index)`: Removes a specific media file.
- `updateCaption(String value)`: Updates the media caption.
- `clearMedia()`: Clears all selected media and caption.
- `setPostType(PostType value)`: Sets the context type.

**Usage Example:**
```dart
// Set the context in initState
@override
void initState() {
  super.initState();
  context.read<MediaPreviewViewModel>().setPostType(PostType.forum);
}

// Add media files
context.read<MediaPreviewViewModel>().addMedia(["path/to/image.jpg"]);

// Update caption
context.read<MediaPreviewViewModel>().updateCaption("My new post");

// Clear everything
context.read<MediaPreviewViewModel>().clearMedia();
```

## RecordingViewModel

`RecordingViewModel` handles audio recording functionality for voice messages in chats and forums.

**Key Properties:**
- `recordingState`: Current state of recording (stopped, recording, paused, finished).
- `recordDuration`: Duration of the current recording in seconds.
- `recordedFilePath`: Path to the recorded audio file.

**Key Methods:**
- `startRecording()`: Starts recording audio.
- `stopRecording()`: Stops recording and saves the file.
- `pauseRecording()`: Pauses the current recording.
- `finishRecording()`: Finalizes the recording.

**Usage Example:**
```dart
// Start recording
await context.read<RecordingViewModel>().startRecording();

// Stop recording
await context.read<RecordingViewModel>().stopRecording();

// Get the recorded file path
String? audioPath = context.read<RecordingViewModel>().recordedFilePath;

// Discard recording
context.read<RecordingViewModel>().finishRecording(discard: true);
```

## Integration Between View Models

These view models work together to provide a cohesive experience:

1. `RecordingViewModel` creates audio files that can be played using `AudioPlaybackManager`
2. `MediaPreviewViewModel` can handle media files including those recorded by `RecordingViewModel`
3. `InputfieldViewModel` manages replies that may reference media managed by `MediaPreviewViewModel`

For example, in a forum chat:
- User can record audio using `RecordingViewModel`
- The audio can be attached to a message via `MediaPreviewViewModel`
- Other users can reply to this message using `InputfieldViewModel`
- Users can play the audio using `AudioPlaybackManager` 