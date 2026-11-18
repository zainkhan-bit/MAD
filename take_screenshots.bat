@echo off
REM Runs the Assignment 2 flow test and saves phone screenshots to test\screenshots\
cd /d "%~dp0"
call flutter pub get
call flutter test test\assignment2_screenshots_test.dart
pause
