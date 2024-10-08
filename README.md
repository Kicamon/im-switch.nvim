# im-switch.nvim
neovim的输入法自动切换插件，在写文档以及代码注释的时候可以自动帮忙切换输入法

默认支持fcitx5

功能演示：https://www.bilibili.com/video/BV1U94y1e7HS

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
  input_toggle = 1, -- 设置为0则默认不自动切换，在insert模式下手动切换为中文后启动自动切换
  text = { -- 写文档
    enable = true,
    files = {
      '*.md',
      '*.txt',
    },
  },
  code = { -- 代码注释
    enable = true,
    files = { '*' },
  },
  en = 'fcitx5-remote -c',
  zh = 'fcitx5-remote -o',
  check = 'fcitx5-remote',

})
```

#### 其他输入法
如果你使用的输入法没有被支持，可以这么配置，如fcitx
```lua
require("im-switch").setup({
  en = "fcitx-remote -c",
  zh = "fcitx-remote -o",
  check = "fcitx-remote",
  --这里写上相应的输入法切换命令即可
})
```

### 适用范围
- [x] 所有nvim-treesitter支持的编程语言
- [x] markdown及其代码块
- [ ] tex

### License MIT
