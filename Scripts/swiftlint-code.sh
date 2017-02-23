if which swiftlint >/dev/null; then
  RESULT=0

  swiftlint lint --no-cache --strict --path "${PROJECT_DIR}/Sources" || { RESULT=1; }
  swiftlint lint --no-cache --strict --path "${PROJECT_DIR}/Tests/StencilSwiftKitTests" || { RESULT=1; }

  exit $RESULT
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
