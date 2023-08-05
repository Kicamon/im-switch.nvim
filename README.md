# im-switch.nvim
neovim的输入法自动切换插件，在写文档以及代码注释的时候可以自动帮忙切换输入法

目前只支持fcitx和fcitx5

功能演示：https://www.bilibili.com/video/BV1U94y1e7HS

### 依赖
插件部分功能依赖[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

### 安装
`Lazy.nvim`
```lua
{
    "Kicamon/im-switch.nvim",
    lazy = true,
    event = { "InsertEnter" },
    config = function()
        require("im-switch").setup()
    end
}
```

### 配置
#### 默认配置
```lua
require("im-switch").setup({
	im = "fcitx5",
	ft_text = { -- 自动切换输入法的文档
		"*.md",
		"*.txt",
	},
	ft_code = { -- 注释时自动切换输入法的语言
		"*.lua",
		"*.c",
		"*.cpp",
		"*.py",
	},
	fcitx5 = {
		en = "fcitx5-remote -c",
		zh = "fcitx5-remote -o",
		check = "fcitx5-remote",
	},
})
```
