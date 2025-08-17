export def create_left_prompt [] {
    let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

export def get_git_branch [] {
    if (which git | is-empty) { return "" }

    let git_current_ref = (do { git rev-parse --abbrev-ref HEAD } | complete | get stdout | str trim)
    if ($git_current_ref != "") { return $"(ansi cyan_bold)[($git_current_ref)](ansi reset)" }

    return ""
}

# Get CONTAINER_ID envar from distrobox
export def get_container_id [] {
	if ($env.CONTAINER_ID? | is-empty) == false {
		return $"(ansi purple_bold) [box:($env.CONTAINER_ID)](ansi reset)"
	} else {
		""
	}
}

export def get_hostname [] {
    ( sys host | get hostname )
}

export def get_username [] {
    $env.USER
}

# Yazi shortcut to exit and CWD
export def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

export def down [link] { curl -O $link } # Alias for download with curl
export def l [] { ls | sort-by type } # Alias for ls and sort-by type
export def la [] { ls --all | sort-by type } # Alias for show all hidden and sort-by type