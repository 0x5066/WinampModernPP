# Winamp Modern-Forked

This is a fork of the classic Winamp Modern that aims to update the base skin on a number of small things, such as weird visual blemishes, updating code where needed, etc.

There are no plans yet to make further modifications to the skin, as the current goal is to keep the original spirit of the skin alive as much as possible, whilst making the smallest of updates that keeps it tidy and modern.

![Screenshot](https://raw.githubusercontent.com/0x5066/WinampModernForked/main/screenshot.png)

This makes use of version detection, where it'll run a version check on skin load and disable a few features and changes the titles of most skinned windows, if Winamp 5.8 was detected.
The checks reside in:
``display.m @ line 33``
``titlebar.m @ line 34``
``visualizer.m @ line 58``

These can be safely removed and won't cause other hidden issues.