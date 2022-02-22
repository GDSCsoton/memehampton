#!/bin/bash
set +e

sudo rm -r build/
flutter build web --web-renderer html
firebase deploy --only hosting
