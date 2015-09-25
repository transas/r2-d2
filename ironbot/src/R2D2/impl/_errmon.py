from sys import argv, exit
from os import  getcwd, chdir
from os.path import dirname, abspath, basename

from robot.run import run


def main(exec_file, test, result_file):
    import logging
    logging.critical(argv)
    d = getcwd()
    chdir(dirname(abspath(exec_file)))
    exec_file = basename(exec_file)
    try:
        res = run(exec_file, output='NONE', report=result_file, log='NONE', test=test)
    finally:
        chdir(d)

    if res:
        exit(1)
    exit(0)



if __name__ == "__main__":
    main(argv[1], argv[2], argv[3])
