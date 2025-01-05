import os
import subprocess
import re
import urllib3

data = {
    "nu": "nushell/nushell",
    "eza": "eza-community/eza",
    "uv": "astral-sh/uv",
    "zoxide": "ajeetdsouza/zoxide",
    "bun": "oven-sh/bun",
    "jj": "jj-vcs/jj",
    "hx": "helix-editor/helix",
}


def get_version_number(tag: str) -> str:
    re_pattern = r"\d+\.\d+\.[\d\w]*|\d+\.\d+"
    return re.findall(pattern=re_pattern, string=tag)[0]


def check_latest_release(repo: str):
    respon = urllib3.request(
        method="GET", url=f"https://api.github.com/repos/{repo}/releases/latest"
    )
    return get_version_number(respon.json().get("tag_name"))


def check_binary_version(binary_path: str) -> str:
    try:
        result = subprocess.run(
            [binary_path, "--version"], capture_output=True, text=True, check=True
        )
        return get_version_number(result.stdout.strip())
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "Version check failed or binary not found/executable."


def main(prog_list: dict):
    res = []
    bin_directory = os.getenv("XDG_BIN_HOME")
    for file_name in os.listdir(bin_directory):
        if file_name.endswith(".exe"):
            file_name = file_name[:-4]

        if file_name in list(prog_list.keys()):
            binary_path = os.path.join(bin_directory, file_name)
            latest = check_latest_release(prog_list.get(file_name))
            if file_name == 'hx':
                latest = latest.replace(".0", ".")
            local = check_binary_version(binary_path)
            if latest == local:
                res.append(f"{file_name} -> {local}")
            else:
                res.append(f"\033[92m{file_name} -> {local} -> {latest}\033[0m")

    for name in res:
        print(name)


if __name__ == "__main__":
    main(data)
