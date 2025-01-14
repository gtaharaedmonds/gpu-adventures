load("@rules_hdl//verilog:defs.bzl", "verilog_library")
load(
    "@rules_hdl//vivado:defs.bzl",
    "vivado_create_project",
    "vivado_flow",
)

verilog_library(
    name = "eq2",
    srcs = [
        "eq1.sv",
        "eq2.sv",
    ],
)

verilog_library(
    name = "eq2_top",
    srcs = [
        "eq2_top.sv",
    ],
    data = [
        "constraints.xdc",
    ],
    deps = [
        ":eq2",
    ],
)

vivado_flow(
    name = "eq2_vivado",
    module = ":eq2_top",
    module_top = "eq2_top",
    part_number = "xc7a200tsbg484-1",
    tags = ["manual"],
    xilinx_env = "//:xilinx_env.sh",
)

vivado_create_project(
    name = "eq2_project",
    module = ":eq2_top",
    module_top = "eq2_top",
    part_number = "xc7a200tsbg484-1",
    tags = ["manual"],
    xilinx_env = "//:xilinx_env.sh",
)
