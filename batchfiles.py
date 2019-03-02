#!/usr/bin/env python

import os
import sys
import argparse


def batchname(prefix, n=0):
    """Create an output filename that does not exist"""
    outpath = "{}{:04d}.batch".format(prefix, n)
    while os.path.exists(outpath):
        n += 1
        outpath = "{}{:04d}.batch".format(prefix, n)
    return outpath


def main(args):
    batch_num = 0
    batch_size = 0
    batch_path = batchname(args.prefix, batch_num)
    fh = open(batch_path, "w")
    for line in sys.stdin:
        line = line.rstrip("\r\n")
        s = os.path.getsize(line)
        if batch_size + s > args.size:
            if batch_size == 0:
                raise Exception("filesize is greater than maxsize: {}".format(line))
            # reset
            batch_num += 1
            batch_size = 0
            batch_path = batchname(args.prefix, batch_num)
            fh = open(batch_path, "w")
        batch_size += s
        print(line, file=fh)


def num_convert(nstr):
    multiplier = 1
    if nstr.endswith("K"):
        multiplier = 1024
    elif nstr.endswith("M"):
        multiplier = 1024 * 1024
    elif nstr.endswith("G"):
        multiplier = 1024 * 1024 * 1024
    else:
        return int(nstr)
    return int(nstr[:-1]) * multiplier


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        "Read list of files from stdin and split into batches based on cumulative file size."
    )
    parser.add_argument(
        "--size", "-s", required=True, help="Maximum size of a batch (e.g. 1G)"
    )
    parser.add_argument(
        "--prefix",
        "-p",
        required=True,
        help="Prefix for output list files (e.g. /data/batches/alice_)",
    )
    args = parser.parse_args()

    # convert size string to number of bytes
    args.size = num_convert(args.size)

    main(args)
