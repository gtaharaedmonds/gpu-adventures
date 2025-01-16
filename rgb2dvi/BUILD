load("@rules_hdl//verilog:defs.bzl", "verilog_library")
load(
    "@rules_hdl//vivado:defs.bzl",
    "vivado_create_project",
    "xsim_test",
)

verilog_library(
    name = "tmds_serializer",
    srcs = ["tmds_serializer.sv"],
)

verilog_library(
    name = "tmds_serializer_tb",
    srcs = ["tmds_serializer_tb.sv"],
    deps = [
        ":tmds_serializer",
    ],
)

xsim_test(
    name = "tmds_serializer_xsim",
    module = ":tmds_serializer_tb",
    module_top = "tmds_serializer_tb",
    part_number = "xc7a200tsbg484-1",
    tags = ["manual"],
    with_waveform = True,
    xilinx_env = "//:xilinx_env.sh",
)

vivado_create_project(
    name = "tmds_serializer_project",
    module = ":tmds_serializer_tb",
    module_top = "tmds_serializer_tb",
    part_number = "xc7a200tsbg484-1",
    tags = ["manual"],
    xilinx_env = "//:xilinx_env.sh",
)

verilog_library(
    name = "tmds_encoder",
    srcs = ["tmds_encoder.sv"],
)

verilog_library(
    name = "tmds_encoder_tb",
    srcs = ["tmds_encoder_tb.sv"],
    deps = [
        ":tmds_encoder",
    ],
)

vivado_create_project(
    name = "tmds_encoder_project",
    module = ":tmds_encoder_tb",
    module_top = "tmds_encoder_tb",
    part_number = "xc7a200tsbg484-1",
    tags = ["manual"],
    xilinx_env = "//:xilinx_env.sh",
)
