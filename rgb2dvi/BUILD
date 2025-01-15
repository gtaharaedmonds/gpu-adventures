load("@rules_hdl//verilog:defs.bzl", "verilog_library")
load(
    "@rules_hdl//vivado:defs.bzl",
    "vivado_create_project",
    "xsim_test",
)

verilog_library(
    name = "tmds_serdes",
    srcs = ["tmds_serdes.sv"],
)

verilog_library(
    name = "tmds_serdes_tb",
    srcs = ["tmds_serdes_tb.sv"],
    deps = [
        ":tmds_serdes",
    ],
)

xsim_test(
    name = "tmds_serdes_xsim",
    module = ":tmds_serdes_tb",
    module_top = "tmds_serdes_tb",
    part_number = "xc7a200tsbg484-1",
    tags = ["manual"],
    with_waveform = True,
    xilinx_env = "//:xilinx_env.sh",
)

vivado_create_project(
    name = "tmds_serdes_project",
    module = ":tmds_serdes_tb",
    module_top = "tmds_serdes_tb",
    part_number = "xc7a200tsbg484-1",
    tags = ["manual"],
    xilinx_env = "//:xilinx_env.sh",
)
