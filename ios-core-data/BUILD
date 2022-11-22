load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load('@build_bazel_rules_swift//swift:swift.bzl', 'swift_library')
load(
    "@com_github_buildbuddy_io_rules_xcodeproj//xcodeproj:defs.bzl",
    "top_level_target",
    "xcodeproj",
)

swift_library(
    name = "AppLibrary",
    srcs = glob([
            "*.swift",
        ],
    ),
    deps = [],
)

ios_application(
    name = "ios-core-data",
    bundle_id = "erwindosianipar.ios-core-data",
    minimum_os_version = "16.0",
    infoplists = [
        "Info.plist",
    ],
    families = [
        "iphone",
    ],
    visibility = [
        "//visibility:public",
    ],
    linkopts = [
        "-interposable",
    ],
    deps = [
        ":AppLibrary",
    ],
)

xcodeproj(
    name = "xcodeproj",
    project_name = "ios-core-data",
    tags = [
        "manual",
    ],
    top_level_targets = [
        top_level_target(
            ":ios-core-data",
            target_environments = [
                "simulator",
            ],
        ),
    ],
)