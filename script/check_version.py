import os
import subprocess
import re
import urllib3
from concurrent.futures import ThreadPoolExecutor, as_completed

data: dict[str, list[str]] = {
    "nu": ["nushell/nushell", "nu"],
    "uv": ["astral-sh/uv", "uv"],
    "zoxide": ["ajeetdsouza/zoxide", "zoxide"],
    "bun": ["oven-sh/bun", "bun"],
    "jj": ["jj-vcs/jj", "jj"],
    "fzf": ["junegunn/fzf", "fzf"],
    "ubi": ["houseabsolute/ubi", "ubi"],
    "gh": ["cli/cli", "gh"],
}

def get_version_number(tag: str) -> str:
    re_pattern = r"\d+\.\d+\.[\d\w]*|\d+\.\d+"
    try:
        return re.findall(pattern=re_pattern, string=tag)[0]
    except IndexError:
        return "Version parse failed"

def check_latest_release(repo: str) -> tuple[str, str]:
    http = urllib3.PoolManager()
    try:
        response = http.request(
            method="GET", 
            url=f"https://api.github.com/repos/{repo}/releases/latest",
            headers={"Accept": "application/vnd.github.v3+json"}
        )
        if response.status == 200:
            tag = response.json().get("tag_name", "")
            return repo, get_version_number(tag)
        else:
            return repo, f"HTTP {response.status}"
    except Exception as e:
        return repo, f"Error: {str(e)}"

def check_binary_version(binary_path: str) -> str:
    try:
        result = subprocess.run(
            [binary_path, "--version"], capture_output=True, text=True, check=True
        )
        return get_version_number(result.stdout.strip())
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "Version check failed or binary not found/executable."

def main(prog_list: dict):
    bin_directory = os.getenv("XDG_BIN_HOME", ".")
    # Collect binaries to check
    binaries_to_check = []
    for file_name in os.listdir(bin_directory):
        if file_name.endswith(".exe"):
            file_name = file_name[:-4]
        if file_name in prog_list:
            binaries_to_check.append((file_name, prog_list[file_name][0]))

    # Parallelize GitHub API calls
    latest_versions = {}
    with ThreadPoolExecutor(max_workers=8) as executor:
        future_to_repo = {executor.submit(check_latest_release, repo): repo for _, repo in binaries_to_check}
        for future in as_completed(future_to_repo):
            repo, version = future.result()
            latest_versions[repo] = version

    # Process and print results
    for file_name, repo in binaries_to_check:
        binary_path = os.path.join(bin_directory, file_name)
        latest = latest_versions.get(repo, "Unknown")
        if file_name == "hx":
            latest = latest.replace(".0", ".")
        local = check_binary_version(binary_path)
        if latest == local:
            print(f"{file_name:<6} -> {local:<8}")
        else:
            print(f"\033[92m{file_name:<6} -> {local:<8} -> {latest}\033[0m")

if __name__ == "__main__":
    main(data)
