from pathlib import Path
from concurrent.futures import ProcessPoolExecutor
import logging

from rdkit import Chem
from rdkit.Chem import AllChem

from ligandparam.recipes import LazyLigand
from ligandparam import __logging_name__, __version__


def set_file_logger(
    logfilename: Path, logname: str = None, filemode: str = "a"
) -> logging.Logger:
    if logname is None:
        logname = Path(logfilename).stem
    logger = logging.getLogger(logname)
    logger.setLevel(logging.INFO)
    formatter = logging.Formatter(
        "{asctime} - {levelname} - {version} {message}",
        style="{",
        datefmt="%Y-%m-%d %H:%M:%S",
        defaults={"version": __version__},
    )
    file_handler = logging.FileHandler(filename=logfilename, mode=filemode)
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    return logger


def set_stdout_logger(logger_name: str) -> logging.Logger:
    logger = logging.getLogger(logger_name)
    logger.setLevel(logging.INFO)  # Set the root logger level to DEBUG

    formatter = logging.Formatter(
        "{asctime} - {levelname} - {version} {message}",
        style="{",
        datefmt="%Y-%m-%d %H:%M:%S",
        defaults={"version": ""},
    )

    stream_handler = logging.StreamHandler(sys.stdout)
    stream_handler.setLevel(logging.INFO)
    stream_handler.setFormatter(formatter)
    logger.addHandler(stream_handler)

    return logger


def worker(node, data_cwd, gaussian_paths):
    cpx_dir = data_cwd / node
    binder_path = Path(cpx_dir, f"binder_{node}.pdb")
    logger = set_file_logger(cpx_dir / f"{node}.log", filemode="w")
    parametrize_ligand = LazyLigand(
        in_filename=binder_path,
        cwd=cpx_dir,
        logger=logger,
        net_charge=0,
        nproc=1,
        atom_type="gaff2",
        mem="4096",
        **gaussian_paths,
    )
    parametrize_ligand.setup()
    parametrize_ligand.execute(dry_run=False)


gaussian_paths = {
    "gaussian_root": "/home/pb777/GAUSSIAN",
    "gauss_exedir": "/home/pb777/GAUSSIAN/g16/bsd:/home/pb777/GAUSSIAN/g16",
    "gaussian_binary": "/home/pb777/GAUSSIAN/g16/g16",
    "gaussian_scratch": "/home/pb777/GAUSSIAN/g16/scratch",
}

home_dir = Path("/home/pb777/reaf_check/jacs/cdk2")
data_dir = home_dir / "data"


binders = [
    "17",
    "1h1q",
    "1h1r",
    "1h1s",
    "1oi9",
    "1oiu",
    "1oiy",
    "20",
    "21",
    "22",
    "26",
    "28",
    "29",
    "30",
    "31",
    "32",
]
data_cwd = data_dir / "preparation"

# worker("17", data_cwd, gaussian_paths)
#
with ProcessPoolExecutor(max_workers=16) as ex:
    futuros = {}
    for binder in binders:
        futu = ex.submit(worker, binder, data_cwd, gaussian_paths)
        futuros[binder] = futu

    for node, futu in futuros.items():
        try:
            futu.result()
            print(f"Got {node}")
        except Exception as e:
            print(f"Failed {node}: {e}")
            continue
