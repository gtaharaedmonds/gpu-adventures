workspace(name = "gpu_adventures")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "rules_python",
    sha256 = "e3f1cc7a04d9b09635afb3130731ed82b5f58eadc8233d4efb59944d92ffc06f",
    strip_prefix = "rules_python-0.33.2",
    url = "https://github.com/bazelbuild/rules_python/releases/download/0.33.2/rules_python-0.33.2.tar.gz",
)

load(
    "@rules_python//python:repositories.bzl",
    "py_repositories",
    "python_register_toolchains",
)

py_repositories()

python_register_toolchains(
    name = "python10",
    python_version = "3.10",
)

http_archive(
    name = "rules_proto",
    sha256 = "6fb6767d1bef535310547e03247f7518b03487740c11b6c6adb7952033fe1295",
    strip_prefix = "rules_proto-6.0.2",
    url = "https://github.com/bazelbuild/rules_proto/releases/download/6.0.2/rules_proto-6.0.2.tar.gz",
)

rules_hdl_git_hash = "471281d09bfa640567181037029bd0644ced2819"

rules_hdl_git_sha256 = "88a5f397252a20eaeb9d2b2fd3b8a48175b6b39f8b398a0c9b33d610dd8ef4db"

http_archive(
    name = "rules_hdl",
    sha256 = rules_hdl_git_sha256,
    strip_prefix = "bazel_rules_hdl-%s" % rules_hdl_git_hash,
    urls = [
        "https://github.com/gtaharaedmonds/bazel_rules_hdl/archive/%s.tar.gz" % rules_hdl_git_hash,
    ],
)

load("@rules_hdl//dependency_support:dependency_support.bzl", rules_hdl_dependency_support = "dependency_support")

rules_hdl_dependency_support()

load("@rules_hdl//:init.bzl", rules_hdl_init = "init")

rules_hdl_init()
