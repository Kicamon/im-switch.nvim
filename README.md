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

#### 其他输入法
如果你使用的输入法没有被支持，可以这么配置
```lua
require("im-switch").setup({
	im = "im",--这里写输入法名称
	ft_text = { -- 自动切换输入法的文档
        --文档类型
	},
	ft_code = { -- 注释时自动切换输入法的语言
        --代码类型
	},
	im = {
		en = "",
		zh = "",
		check = "",
        --这里协商相应的输入法切换命令即可
	},
})
```

### 适用范围
- [x] 所有nvim-treesitter支持的编程语言
- [x] markdown及其代码块
- [ ] tex
