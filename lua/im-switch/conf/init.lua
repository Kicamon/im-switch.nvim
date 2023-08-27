local opt = {}

opt = {
	im = "fcitx5",
	ft_text = {
		"*.md",
		"*.txt",
	},
	ft_code = {
    "*",
	},
	fcitx5 = {
		en = "fcitx5-remote -c",
		zh = "fcitx5-remote -o",
		check = "fcitx5-remote",
	},
	fcitx = {
		en = "fcitx-remote -c",
		zh = "fcitx-remote -o",
		check = "fcitx-remote",
	},
}

return opt
