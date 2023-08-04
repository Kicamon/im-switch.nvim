# im-switch.nvim
neovim的输入法自动切换插件，在写文档以及代码注释的时候可以自动帮忙切换输入法

目前只支持fcitx和fcitx5

### 依赖
插件部分功能依赖[nvim-treesitter](nvim-treesitter/nvim-treesitter)

### 安装
`Lazy.nvim`
```lua
{
    "Kicamon/im-switch.nvim",
}
end
```

### 配置
#### 默认配置
```lua
require("im-switch").setup({
    im = "fcitx5",
})
```


