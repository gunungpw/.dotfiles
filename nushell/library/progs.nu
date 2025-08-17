# Data mapping for binaries, including their GitHub project, executable name, and version flag
const data = {
    nu: ["nushell/nushell", "nu", "--version"],
    uv: ["astral-sh/uv", "uv", "--version"],
    zoxide: ["ajeetdsouza/zoxide", "zoxide", "--version"],
    bun: ["oven-sh/bun", "bun", "--version"],
    jj: ["jj-vcs/jj", "jj", "--version"],
    fzf: ["junegunn/fzf", "fzf", "--version"],
    ubi: ["houseabsolute/ubi", "ubi", "--version"],
    gh: ["cli/cli", "gh", "--version"],
    yazi: ["sxyazi/yazi", "yazi", "--version"],
    micro: ["zyedidia/micro", "micro", "--version"],
    lazygit: ["jesseduffield/lazygit", "lazygit", "--version"]
}

# Ensures XDG_BIN_HOME is set and the directory exists
# Returns true if successful, false otherwise
def ensure-bin-directory [] {
    let bin_directory = ($env.XDG_BIN_HOME? | default null)
    if $bin_directory == null {
        print "Error: XDG_BIN_HOME environment variable is not set"
        return false
    }

    if not ($bin_directory | path exists) {
        print $"Creating directory ($bin_directory)..."
        try {
            mkdir $bin_directory
        } catch {
            print $"Failed to create directory ($bin_directory)"
            return false
        }
    }
    return true
}

# Downloads a specified binary using ubi
export def binary-get [bin_name: string] {
    if not (ensure-bin-directory) { return [] }

    let base = $data | get $bin_name
    do { ubi --project $base.0 --in $env.XDG_BIN_HOME --exe $base.1 -v }
}

# Checks availability of binaries in XDG_BIN_HOME
export def binary-check [] {
    if not (ensure-bin-directory) { return [] }

    $data | transpose key value | par-each { |row|
        let bin_name = $row.key
        let is_present = ($bin_name in (ls $env.XDG_BIN_HOME | get name | path basename))
        
        if $is_present {
            let version = ^$bin_name --version | (parse --regex '(\d+\.\d+\.\d+)').capture0.0
            { Binary: $bin_name, Status: $"(ansi green_bold)Found(ansi reset)", Version: $version }
        } else {
            { Binary: $bin_name, Status: $"(ansi red_bold)Not Found(ansi reset)", Version: "-" }
        }
    }
}

# Downloads missing binaries and returns their status
export def binary-get-missing [] {
    if not (ensure-bin-directory) { return [] }

    # Collect missing binaries
    let not_found = ($data | transpose key value | reduce --fold [] { |row, acc|
        let bin_name = $row.key
        let is_present = ($bin_name in (ls $env.XDG_BIN_HOME | get name | path basename))
        if $is_present {
            $acc
        } else {
            $acc | append $bin_name
        }
    })

    # If no binaries are missing, inform the user
    if ($not_found | is-empty) { return "All binaries are already present." }

    # Download missing binaries and collect results
    $not_found | each { |bin_name|
        print $"Downloading ($bin_name)..."
        binary-get $bin_name
    }
}