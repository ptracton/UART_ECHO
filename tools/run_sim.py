#! /usr/bin/env python3

"""
run_sim.py

Run FPGA simulations via Icarus, NCVerilog, Modelsim or Isim.

"""

import json
import os
import shlex
import subprocess
import sys
import argparse


def which(program):
    """
    Find the path to an executable program
    """

    def is_exe(fpath):
        """
        Return True is the fpath exists and is executable.  This is needed since the
        executables are specifed in the JSON files, but not the path to them.  The
        executables may be in different locations based on which PC is running this.
        """
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Run FPGA Simulation')
    parser.add_argument("-D", "--debug",
                        help="Debug this script",
                        action="store_true")
    parser.add_argument("--icarus",
                        help="Use Icarus Verilog",
                        action="store_true")
    parser.add_argument("--ncverilog",
                        help="Use NCVerilog",
                        action="store_true")
    parser.add_argument("--modelsim",
                        help="Use Altera Modelsim",
                        action="store_true")
    parser.add_argument("--isim",
                        help="Use Xilinx ISim",
                        action="store_true")
    parser.add_argument("--xsim",
                        help="Use Xilinx Vivado XSim",
                        action="store_true")
    

    args = parser.parse_args()
    if args.debug:
        print(args)

    if args.icarus:
        json_file = "../../configurations/simulate_iverilog.json"
    if args.ncverilog:
        json_file = "../../configurations/simulate_ncverilog.json"
    if args.modelsim:
        json_file = "../../configurations/simulate_modelsim.json"
    if args.isim or args.xsim:
        json_file = "../../configurations/simulate_isim.json"

    try:
        f = open(json_file, "r")
        json_data = json.load(f)
    except:
        print("Failed to open %s" % (json_file))
        sys.exit(-1)

    flow_steps = json_data['flow_steps']
    print(flow_steps)

    for step in sorted(flow_steps.keys()):
        print("Running Step: %s " % step)
        executable = json_data['flow'][flow_steps[step]]['executable']
        arguments = json_data['flow'][flow_steps[step]]['arguments']
        executable = which(executable)
        print(executable)
        if (arguments == None):
            command = executable
        else:
            command = executable + " " + arguments

        print(command)
        command = shlex.split(command)
        p = subprocess.Popen(command)
        p.communicate()
