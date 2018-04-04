---
title: bitmap的用途
date: 2017-09-10 14:02:51
tags: 
    - Algorithm
---

# 什么是bitmap

一个bit是数据存储的最小的单位，为0或1。bitmap是一组连续的bit，通过这些bit可以实现海量数据的查找、过滤等功能。

# bitmap的用途

## 查找

设想一个场景，系统有很多很多的用户，同时系统有用户画像的功能，即给用户打上标签，如`IT狗`，`学生党`，`技术宅`等，如果用关系型数据库来存储这些信息的话，面对稀奇古怪的根据标签过滤的需求时，会产生非常丑陋的SQL语句。用bitmap的话则可以通过位运算符轻松的解决这些问题。

### 构建

可以把bitmap看成一个数组,数组的下标是用户的id。比如上面的`IT狗`，`学生`，`美女`三个标签，我们可以用三个bitmap来表示。

```
itdog = bitmap[max]             
student = bitmap[max]           
beauty = bitmap[max]              

user = bitmap[max]  # user[id] = 1 iff 编号为id的用户存在 (后面需要用到这个信息)

```

### 例子

* 为id=xx的用户加上`IT狗`标签：`itdog[xx] = 1`
* 查找所有带有`学生`标签的的用户ID：`filter(range(max), lambda id:student[id]==1)`
* 查找所有的`美女学生`ID：与运算即可，`filter(range(max), lambda id:(student & beauty)[id]==1)`
* 查找所有的`学生`或`IT狗`：或运算即可，`filter(range(max), lambda id:(student | itdog)[id]==1)`
* 查找所有`非学生`用户：要用user，因为值为0的id也可能不存在。`filter(range(max), lambda id:(student ^ user)[id]==1)`

## 过滤

很多爬虫由于要爬取海量的数据，如何避免爬取重复的url是一个很重要的问题，如果用，著名的布隆过滤器(Bloom Filter)便是用了bitmap来实现的一个过滤算法。 

### 利用bitmap做简单的过滤

首先对url进行hash得到一个数值，然后查看bitmap中这个数值的位置是否为1，为1则说明已经抓取过这个url，不再重复抓取。

这种情况容易出现的问题是即使把hashCode的范围设置的非常大，也会有较高的误判率，不同的url出现相同的hashCode导致一些url没能被抓取

### Bloom Filter

Bloom Filter是引进多个hash函数，对每一个url计算出hashCode1，hashCode2，hashCode3，然后仅当这三个位置的bit都为1的时候才判断为重复，这样可以大大的降低重复率。

#### 存储系统中的Bloom Filter

Bloom Filter还可以用于数据存储系统中，在查找数据之前，现在位图中判断数据是否存在，如果存在再去读取数据的值，可以大大减少查询的时间。

##### 插入数据

插入数据时将计算出来的hashCode位置的bit设为1即可

##### 查找数据

如果计算出来的hashCode位置的bit都为1，才进入查找流程，（即使因为重复的hashCode导致最终发现数据不存在，也是极少数情况）

##### 删除数据

删除数据时，会导致bitmap结构被破坏，因为不能因为有一条数据被删除就把其hashCode对应位数都置为0（可能还有其他数据有相同hashCode）。如果要避免破坏数据，需要将一个bit增加到多个bit，这样才能有计数功能。
