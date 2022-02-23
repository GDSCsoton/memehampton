#!/bin/bash
set +e

rm -r build/
flutter build web --web-renderer canvaskit
firebase deploy --only hosting:memehampton
