---
title: Golang 国际化及 CLDR
copyright: true
date: 2023-02-09 00:00:00
urlname: golang-i18n-CLDR
tags: 
 - CLDR
 - Golang
 - i18n
categories: golang
---
# CLDR 复数形式 
> https://cldr.unicode.org/  
> http://docs.translatehouse.org/projects/localization-guide/en/latest/l10n/pluralforms.html

> 不同语言的名词可以有几种复数形式。 它们的用法取决于单词前面的数字，以指示该单词表示的数目。  
例如，当谈论不同数量时，英语单词有两种单词形式。例如 'one star' 或 'two stars'。 无论您说的是五颗星，二十六颗星还是五百三十二颗星，结尾 's' 都将保持不变。 但是有些语言只有一种形式，反之，有些语言也可以有更多种复数形式。  
与英语相比，波兰语里的名词具有三种复数形式。 在说单数形式时使用一种形式，复数形式时以 2-4 数字为结尾的名词（不包括 12-14）使用另一种形式。但还有第三种形式，前面带有其他数字的单词。

中文的名词，对于无生命的是没有复数形式的，例如桌子们、椅子们、电脑们都是不可取的。  

对于动物，也不会讲猫们、狗们、兔子们，而是那些兔子、那些猫、这些狗等。但是在以动物为主角的纪录片或者电影中，出现拟人态势时，可以讲**猎犬们**和**狮子们**在争抢食物。  

对于人类这种高智慧性、高生命度的，则会讲你们、我们、他们、老师们、同志们、工人们。  

所以中文的 CLDR 在 i18n 中很是有限，因此在做 i18n 时，默认中日英时只用做英文的复数，在对待**人**时，再做中文的 CLDR 即可。
<!-- more -->


# go-i18n
官网：https://github.com/nicksnyder/go-i18n

语言：https://www.unicode.org/cldr/cldr-aux/charts/28/supplemental/language_plural_rules.html


> active.zh.toml
```toml
[PersonCats]
other = "{{.Name}} 有猫"
[Thanks]
other = "谢谢"
```

> active.ja.toml
```toml
[PersonCats]
other = "{{.Name}} は猫を飼っています"
[Thanks]
other = "ありがとう"
```

> go.mod
``` text
module main

go 1.19
```

> main.go
```golang
package main

import (
	"fmt"

	"github.com/BurntSushi/toml"
	"github.com/nicksnyder/go-i18n/v2/i18n"
	"golang.org/x/text/language"
)

func main() {

	//创建 bundle，默认英文
	bundle := i18n.NewBundle(language.English)
	//注册使用 toml 为模板
	bundle.RegisterUnmarshalFunc("toml", toml.Unmarshal)
	//加载中文翻译
	bundle.MustLoadMessageFile("active.zh.toml")
	//加载日文翻译
	bundle.MustLoadMessageFile("active.ja.toml")

	//创建 localizer，分别为：bundle 对象、变量和语言
	name := "Bob"
	catNums := 1 //英文 CLDR，为 1 时为 one，为其他时为 other
	localizer := i18n.NewLocalizer(bundle, name, "ja")

	//创建消息，英文的默认就是本条
	helloPerson := localizer.MustLocalize(&i18n.LocalizeConfig{
		DefaultMessage: &i18n.Message{
			ID:    "PersonCats",
			One:   "{{.Name}} has cat",
			Other: "{{.Name}} has too many cats ",
		},
		MessageID:   "PersonCats",
		PluralCount: catNums, //数量为多少
		TemplateData: map[string]string{
			"Name": name,
		},
	})
	fmt.Println(helloPerson)

}

```



