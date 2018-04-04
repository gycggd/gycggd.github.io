---
title: "LeetCode 435. Non-overlapping Intervals"
date: 2018-03-29T18:39:49+08:00
tags:
    - Greedy
categories:
    - LeetCode
---

![desc](/images/leetcode/435_1.png)

这一题是很常见的一道区间的问题，其他的外壳如task schedule。

只需要把区间按结束点排序，然后尽量从左往右遍历一次即可。代码如下：

```
class Solution:
    def eraseOverlapIntervals(self, intervals):
        intervals.sort(key=lambda x:x.end)        
        end = -sys.maxsize
        count = 0
        for i in intervals:
            if i.start<end: continue
            end = i.end
            count += 1
        return len(intervals)-count
```