---
title: Golang、CLDR 及国际化
copyright: true
date: 2023-02-09 00:00:00
urlname: golang-CLDR-i18n
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

对于动物，也不会讲猫们、狗们、兔子们，而是那些兔子、那些猫、这些狗等。但是在以动物为主角的纪录片或者电影中，出现拟人态势时，可以称呼这些**猎犬们**和那些**狮子们**争抢食物。  

对于人类这种高智慧性、高生命度的，则会讲你们、我们、他们、老师们、同志们、工人们。  

所以中文的 CLDR 在 i18n 中很是有限，这点在日文中同理，因此在做 i18n 时，默认中日英时只用做英文的名字即可，在对待**人**时，在做中日的 CLDR 即可。
<!-- more -->


# go-i18n
官网：https://github.com/nicksnyder/go-i18n

语言：https://www.unicode.org/cldr/cldr-aux/charts/28/supplemental/language_plural_rules.html


> active.zh.toml
```toml

```

> active.ja.toml
```toml

```

> go.mod
``` text
module main

go 1.19
```

> main.go
```golang

```



