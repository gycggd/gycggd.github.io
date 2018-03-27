---
title: "LeetCode 371. Sum of Two Integers"
date: 2018-03-27T18:34:12+08:00
tags:
    - Bit Manipulation
    - Single Number
categories:
    - Leetcode
---


![desc](/images/leetcode/371_1.png)

这一题是不准用`+-*/`来计算两个整数之和。

很容易想到是用位运算来做。

a和b之和包括两个部分，一个部分是a或b在某一位上有一个为1，这部分可以用a^b取出来。另一部分是a或b在某一位上都为1，这部分可以用(a&b)<<1得到。

所以重复这个操作直至b为0然后返回a即可。代码如下(Python整数要自己取mask不然会max recursion exceed)：

```
class Solution:
    def getSum(self, a, b):
        # 32 bits 最大整数
        MAX = 0x7FFFFFFF
        # 32 bits 最小整数
        MIN = 0x80000000
        # 取最小32位的mask
        mask = 0xFFFFFFFF
        
        # 循环至无进位
        while b != 0:
            # “异或”来获得和为1的位，“与”来获得要进位的位，向左移一位即可。总和为两者之和
            a, b = (a ^ b) & mask, ((a & b) << 1) & mask
        # 如果a是负数，需要用mask将高位置为0
        return a if a <= MAX else (a|~mask)
```

